import Foundation
import AVFoundation

class Recorder {
    private let audioEngine: AVAudioEngine
    private let rawAudioTx: AsyncStream<AVAudioPCMBuffer>.Continuation
    
    init(rawAudioTx: AsyncStream<AVAudioPCMBuffer>.Continuation) {
        self.audioEngine = AVAudioEngine()
        self.rawAudioTx = rawAudioTx
        
    }
    
    func startRecording() throws {
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.inputNode.installTap(
            onBus: 0,
            bufferSize: 1024,
            format: audioEngine.inputNode.outputFormat(forBus: 0)
        ) {
            buffer, time in
            
            Task {
                self.rawAudioTx.yield(buffer)
            }
            
        }
        
        audioEngine.prepare()
        try audioEngine.start()
    }
}


