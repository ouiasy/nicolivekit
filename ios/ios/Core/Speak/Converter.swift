@preconcurrency import AVFoundation
import Foundation

/// BufferConverterは,bufferedされた音声データを SpeechAnalyzerに適合したformatに変換する
class BufferConverter {
    private var converter: AVAudioConverter

    private let originalFormat: AVAudioFormat
    private let targetFormat: AVAudioFormat

    init(originalFormat: AVAudioFormat, targetFormat: AVAudioFormat) throws {

        self.originalFormat = originalFormat
        self.targetFormat = targetFormat
        guard
            let converter = AVAudioConverter(
                from: originalFormat,
                to: targetFormat
            )
        else {
            throw ConverterError.failedToCreateConverter
        }

        converter.primeMethod = .none
        self.converter = converter
    }

    func convertBuffer(
        _ buffer: AVAudioPCMBuffer,
    )
        throws -> AVAudioPCMBuffer
    {
        let sampleRateRatio =
            converter.outputFormat.sampleRate / converter.inputFormat.sampleRate
        let scaledInputFrameLength =
            Double(buffer.frameLength) * sampleRateRatio
        let frameCapacity = AVAudioFrameCount(
            scaledInputFrameLength.rounded(.up)
        )

        guard
            let conversionBuffer = AVAudioPCMBuffer(
                pcmFormat: converter.outputFormat,
                frameCapacity: frameCapacity
            )
        else {
            throw ConverterError.failedToCreateConversionBuffer
        }

        var nsError: NSError?
        var bufferProcessed = false

        let status = converter.convert(to: conversionBuffer, error: &nsError) {
            _, inputStatusPointer in

            if bufferProcessed {
                inputStatusPointer.pointee = .noDataNow
                return nil
            } else {
                bufferProcessed = true
                inputStatusPointer.pointee = .haveData
                return buffer
            }
        }

        if status == .error {
            throw ConverterError.conversionFailed(nsError)
        }

        return conversionBuffer

    }
}

enum ConverterError: Error {
    case failedToCreateConverter
    case failedToCreateConversionBuffer
    case conversionFailed(NSError?)
}
