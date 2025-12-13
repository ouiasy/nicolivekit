import Foundation
import Connect

@Observable
class ClientState {

    private(set) var connectClient: ConnectClient?

    func createClient(host: String, port: String) {
        guard !host.isEmpty, !port.isEmpty else {
            print("host or port empty")
            return
        }
        self.connectClient = ConnectClient(host: host, port: port)
        print("connectClient created")
    }

    func send(text: String) async -> String? {
        print("send called")
        guard let client = connectClient else {
            print("client is nil")
            return "Client not connected"
        }
        let response = await client.sendText(text)
        print("response received: \(response)")
        
        return response.message?.message
    }
}

