import Foundation
import Speech

class Transcriber {
    private let processedAudioRx: AsyncStream<AnalyzerInput>
    private let processedTextTx: AsyncStream<AttributedString>.Continuation
    
    private let transcriber: SpeechTranscriber
    private let analyzer: SpeechAnalyzer
    let analyzerFormat: AVAudioFormat?

    init(
        processedAudioRx: AsyncStream<AnalyzerInput>,
        processedTextTx: AsyncStream<AttributedString>.Continuation
    ) async {
        self.processedAudioRx = processedAudioRx
        self.processedTextTx = processedTextTx

        self.transcriber = SpeechTranscriber(
            locale: Locale(identifier: "ja-JP"),  //TODO: set locale
            transcriptionOptions: [],
            reportingOptions: [.volatileResults],
            attributeOptions: [.audioTimeRange]
        )
        self.analyzer = SpeechAnalyzer(modules: [self.transcriber])

        self.analyzerFormat = await SpeechAnalyzer.bestAvailableAudioFormat(
            compatibleWith: [transcriber])
    }

    func startTranscribe() async throws {
        let resultsStream = self.transcriber.results
        let textTx = self.processedTextTx

        // TODO: use task group
        Task {
            do {
                for try await res in resultsStream {
                    if res.isFinal {
                        textTx.yield(res.text)
                        print(res.text)
                    }
                }
            } catch {
                print("speech recognition error")
            }
        }

        try await self.analyzer.start(inputSequence: processedAudioRx)
    }
}
