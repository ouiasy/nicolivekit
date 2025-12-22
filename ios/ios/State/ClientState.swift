import Connect
import Foundation
import SwiftUI

@MainActor
@Observable
final class ClientState {
    private(set) var connectVoiceClient: ConnectClient?

    // TODO: set pipeline
    private let processedTextRx: AsyncStream<String>

    var responses: [String] = []

    init(config: AppConfig, processedTextRx: AsyncStream<String>) {
        self.connectVoiceClient = ConnectClient(
            host: config.vHost,
            port: config.vPort
        )
        self.processedTextRx = processedTextRx
        print("connectClient created")
    }

    func startClient() async {
        print("client started")
        let textStream = processedTextRx
        Task {
            for await text in textStream {
                let res = await send(text: text)
                if let res {
                    responses.append(res)
                }
            }
        }

    }

    private func send(text: String) async -> String? {
        print("send called")
        guard let client = connectVoiceClient else {
            print("client is nil")
            return "Client not connected"
        }
        let response = await client.sendText(text)

        return response.message?.message
    }
}
