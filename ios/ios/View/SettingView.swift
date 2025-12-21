import SwiftUI

struct SettingView: View {
    @Environment(ClientState.self) var clientState: ClientState
    @Environment(\.dismiss) var dismiss
    
    @State private var chatHost: String = ""
    @State private var chatPort: String = ""
    @State private var trackingHost: String = ""
    @State private var trackingPort: String = ""
    @State private var liveID: String = ""
    
    var body: some View {
        @Bindable var clientState = clientState
        NavigationStack {
            Form {
                Section("Chat") {
                        TextField("host", text: $chatHost)
                        TextField("port", text: $chatPort)
                }
                Section("Face Tracking") {
                    TextField("host", text: $trackingHost)
                    TextField("port", text: $trackingPort)
                }
                Section("Live ID") {
                    TextField("LiveID", text: $liveID)
                }
            }.onAppear {
                chatHost = clientState.settings.vHost
                chatPort = clientState.settings.vPort
                trackingHost = clientState.settings.tHost
                trackingPort = clientState.settings.tPort
                liveID = clientState.settings.liveID
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        clientState.settings.vHost = chatHost
                        clientState.settings.vPort = chatPort
                        clientState.settings.tHost = trackingHost
                        clientState.settings.tPort = trackingPort
                        clientState.settings.liveID = liveID
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingView()
        .environment(ClientState())
}
