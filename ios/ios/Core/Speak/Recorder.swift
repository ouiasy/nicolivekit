import Foundation
import AVFoundation

class Recorder {
    private let audioEngine: AVAudioEngine
    private let audioPipeline: AudioPipeline
    private let converter: BufferConverter
    
    init(rawAudioTx: AsyncStream<AVAudioPCMBuffer>.Continuation, originalFormat: AVAudioFormat, targetFormat: AVAudioFormat) throws {
        self.audioEngine = AVAudioEngine()
        self.audioPipeline = AudioPipeline()
        self.converter = try BufferConverter(originalFormat: originalFormat, targetFormat: targetFormat)
    }
    
    func startRecording() throws {
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.inputNode.installTap(
            onBus: 0,
            bufferSize: 1024,
            format: audioEngine.inputNode.outputFormat(forBus: 0)
        ) {
            buffer, time in
            // TODO: convert buffer and own value
            let convertedBuffer = try? self.converter.convertBuffer(buffer)
            if let convertedBuffer {
                let sendableBuffer = SendableAudioBuffer(convertedBuffer)
                self.audioPipeline.push(sendableBuffer)
                return
            }
        }
        
        audioEngine.prepare()
        try audioEngine.start()
    }
}


