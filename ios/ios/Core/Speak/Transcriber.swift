import Foundation
import Speech

class Transcriber {
    private let processedAudioRx: AsyncStream<AnalyzerInput>
    private let processedTextTx: AsyncStream<String>.Continuation

    private let transcriber: SpeechTranscriber
    private let analyzer: SpeechAnalyzer
    let analyzerFormat: AVAudioFormat?

    init(
        processedAudioRx: AsyncStream<AnalyzerInput>,
        processedTextTx: AsyncStream<String>.Continuation
    ) async {
        self.processedAudioRx = processedAudioRx
        self.processedTextTx = processedTextTx

        self.transcriber = SpeechTranscriber(
            locale: Locale(identifier: "ja_JP"),  //TODO: set locale
            transcriptionOptions: [],
            reportingOptions: [],
            attributeOptions: []
        )
        let speechDetector = SpeechDetector()
        self.analyzer = SpeechAnalyzer(modules: [
            speechDetector, self.transcriber,
        ])

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
                        textTx.yield(String(res.text.characters))
                        let plainText = String(res.text.characters)
                        print(plainText)
                    }
                }
            } catch {
                print("speech recognition error")
            }
        }

        try await self.analyzer.start(inputSequence: processedAudioRx)
    }
}
