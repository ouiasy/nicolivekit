import Foundation
import AVFoundation
import Speech

class Recorder {
    private let audioEngine: AVAudioEngine
    private let converter: BufferConverter
    private let processedAudioTx: AsyncStream<AnalyzerInput>.Continuation
    
    init(processedAudioTx: AsyncStream<AnalyzerInput>.Continuation,
         targetFormat: AVAudioFormat) throws {
        self.audioEngine = AVAudioEngine()
        self.processedAudioTx = processedAudioTx
        let originalFormat = self.audioEngine.inputNode.inputFormat(forBus: 0)
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
            let convertedBuffer = try? self.converter.convertBuffer(buffer)
            if let convertedBuffer {
                let input = AnalyzerInput(buffer: convertedBuffer)
                self.processedAudioTx.yield(input)
            }
        }
        
        audioEngine.prepare()
        try audioEngine.start()
    }
}


