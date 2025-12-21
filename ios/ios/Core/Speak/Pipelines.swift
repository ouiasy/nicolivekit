import Foundation
import AVFoundation


struct AppPipelines {
    var rawAudioRx: AsyncStream<AVAudioPCMBuffer>
    var rawAudioTx: AsyncStream<AVAudioPCMBuffer>.Continuation
    
    var processedAudioRx: AsyncStream<AVAudioPCMBuffer>
    var processedAudioTx: AsyncStream<AVAudioPCMBuffer>.Continuation
    
    var processedTextRx: AsyncStream<AttributedString>
    var processedTextTx: AsyncStream<AttributedString>.Continuation
    
    init() {
        (rawAudioRx, rawAudioTx) = AsyncStream<AVAudioPCMBuffer>.makeStream() // TODO: makeStreamの引数の確認
        (processedAudioRx, processedAudioTx) = AsyncStream<AVAudioPCMBuffer>.makeStream()
        (processedTextRx, processedTextTx) = AsyncStream<AttributedString>.makeStream()
    }
}
