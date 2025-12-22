import AVFoundation
import Speech

@MainActor
@Observable
class AudioState {
    var isReady = false
    var isRecording = false
    var errorMessage: String?

    private var transcriber: Transcriber?
    private var recorder: Recorder?

    init() {}

    func start()  throws {
        
        guard !isRecording else { return }
        
        Task {
            do {
                print("録音開始処理...")
                try self.recorder?.startRecording()

                // Transcriber開始 (これはループして待機し続ける)
                try await self.transcriber?.startTranscribe()
                
                isRecording = true

            } catch {
                // エラーが起きたら画面に表示できるようにする
                self.errorMessage = "録音エラー: \(error.localizedDescription)"
                self.isRecording = false  // フラグ戻す
            }
        }
    }

    func setupSession(
        processedAudioRx: AsyncStream<AnalyzerInput>,
        processedAudioTx: AsyncStream<AnalyzerInput>.Continuation,
        processedTextRx: AsyncStream<String>,
        processedTextTx: AsyncStream<String>.Continuation
    ) async {
        do {
            self.transcriber = await Transcriber(
                processedAudioRx: processedAudioRx,
                processedTextTx: processedTextTx
            )

            
            guard let format = self.transcriber?.analyzerFormat else {
                throw NSError(
                    domain: "AudioError",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Format not found"]
                )
            }

            self.recorder = try Recorder(
                processedAudioTx: processedAudioTx,
                targetFormat: format
            )
            


            self.isReady = true

        } catch {
            print(error)
            self.errorMessage = error.localizedDescription
        }
    }
}
