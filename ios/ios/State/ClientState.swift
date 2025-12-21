import Foundation
import Connect
import SwiftUI

@Observable
final class ClientState {
    var settings = ClientSettings()
    
    private(set) var connectVoiceClient: ConnectClient?

    func createClient() {
        self.connectVoiceClient = ConnectClient(host: settings.vHost, port: settings.vPort)
        print("connectClient created")
    }

    func send(text: String) async -> String? {
        print("send called")
        guard let client = connectVoiceClient else {
            print("client is nil")
            return "Client not connected"
        }
        let response = await client.sendText(text)
        print("response received: \(response)")
        
        return response.message?.message
    }
}

struct ClientSettings {
    @AppStorage("voice.host") var vHost: String = "localhost"
    @AppStorage("voice.port") var vPort: String = "8080"
    
    @AppStorage("tracking.host") var tHost: String = "localhost"
    @AppStorage("tracking.port") var tPort: String = "8081"
    
    @AppStorage("liveID") var liveID: String = ""
}
