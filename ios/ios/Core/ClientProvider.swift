import Foundation
import Connect

@Observable
class ClientState {

    private(set) var connectClient: ConnectClient?

    func createClient(host: String, port: String) {
        guard !host.isEmpty, !port.isEmpty else { return }
        self.connectClient = ConnectClient(host: host, port: port)
    }

    func send(text: String) async -> String? {
        guard let client = connectClient else {
            return "Client not connected"
        }
        let response = await client.sendText(text)
        return response.message?.message
    }
}

