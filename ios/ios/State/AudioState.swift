import AVFoundation
import Speech

@Observable
class AudioState {
    var isReady = false
    var errorMessage: String?

    private let pipeline = AppPipelines()
    private var transcriber: Transcriber?
    private var recorder: Recorder?

    init() {}

    func setupSession() async {
        do {
            self.transcriber = await Transcriber(
                processedAudioRx: pipeline.processedAudioRx,
                processedTextTx: pipeline.processedTextTx
            )

            print("session開始1!!")
            guard let format = self.transcriber?.analyzerFormat else {
                throw NSError(
                    domain: "AudioError",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Format not found"]
                )
            }

            print("session開始2!!")

            print("session開始3!!")
            self.recorder = try await Recorder(
                processedAudioTx: pipeline.processedAudioTx,
                targetFormat: format
            )

            self.isReady = true
            
        

        } catch {
            print(error)
            self.errorMessage = error.localizedDescription
        }
    }
}
