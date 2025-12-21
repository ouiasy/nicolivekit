import Foundation
import AVFoundation
import Speech


actor AppPipelines {
    
    var processedAudioRx: AsyncStream<AnalyzerInput>
    var processedAudioTx: AsyncStream<AnalyzerInput>.Continuation
    
    var processedTextRx: AsyncStream<AttributedString>
    var processedTextTx: AsyncStream<AttributedString>.Continuation
    
    init() {
        // TODO: makeStreamの引数の確認
        (processedAudioRx, processedAudioTx) = AsyncStream<AnalyzerInput>.makeStream()
        (processedTextRx, processedTextTx) = AsyncStream<AttributedString>.makeStream()
    }
    
}

