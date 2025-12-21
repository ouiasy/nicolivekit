import AVFoundation
import Foundation

actor TextPipeline {

    var processedTextRx: AsyncStream<AttributedString>
    var processedTextTx: AsyncStream<AttributedString>.Continuation

    init() {
        // TODO: makeStreamの引数の確認

        (processedTextRx, processedTextTx) = AsyncStream<AttributedString>
            .makeStream()
    }

}


// ラッパー構造体を定義
struct SendableAudioBuffer: @unchecked Sendable {
    let buffer: AVAudioPCMBuffer
    
    // 必要なら初期化子を追加
    init(_ buffer: AVAudioPCMBuffer) {
        self.buffer = buffer
    }
}

actor AudioPipeline {
    var processedAudioRx: AsyncStream<SendableAudioBuffer>
    private nonisolated let processedAudioTx: AsyncStream<SendableAudioBuffer>.Continuation

    init() {
        (processedAudioRx, processedAudioTx) = AsyncStream<SendableAudioBuffer>.makeStream()
    }

    nonisolated func push(_ buffer: SendableAudioBuffer) {
        processedAudioTx.yield(buffer)
    }
}
