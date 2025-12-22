import Foundation
import AVFoundation
import Speech


final class AppPipelines {
    
    var processedAudioRx: AsyncStream<AnalyzerInput>
    var processedAudioTx: AsyncStream<AnalyzerInput>.Continuation
    
    var processedTextRx: AsyncStream<String>
    var processedTextTx: AsyncStream<String>.Continuation
    
    init() {
        // TODO: makeStreamの引数の確認
        (processedAudioRx, processedAudioTx) = AsyncStream<AnalyzerInput>.makeStream()
        (processedTextRx, processedTextTx) = AsyncStream<String>.makeStream()
    }
    
}

