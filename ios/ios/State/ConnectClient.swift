import Connect
import SwiftProtobuf

struct ConnectClient {
    var host: String?
    var port: String?
    var client: Synthesize_V1_SpeechServiceClient

    init(host: String, port: String) {
        self.host = host
        self.port = port

        let protocolClient = ProtocolClient(
            httpClient: URLSessionHTTPClient(),
            config: ProtocolClientConfig(
                host: "http://\(host):\(port)",
                networkProtocol: .connect,
                codec: ProtoCodec()
            )
        )
        self.client = Synthesize_V1_SpeechServiceClient(client: protocolClient)
    }

    func sendText(_ text: String) async -> ResponseMessage<Synthesize_V1_SynthesizeResponse> {
        let request = Synthesize_V1_SynthesizeRequest.with { $0.message = text }
        return await client.synthesize(request: request)
    }
}
