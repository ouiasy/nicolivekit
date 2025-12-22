import SwiftUI

struct SettingView: View {
    @Environment(AppConfig.self) var appConfig: AppConfig
    @Environment(\.dismiss) var dismiss
    
    @State private var chatHost: String = ""
    @State private var chatPort: String = ""
    @State private var trackingHost: String = ""
    @State private var trackingPort: String = ""
    @State private var liveID: String = ""
    
    var body: some View {
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
                chatHost = appConfig.vHost
                chatPort = appConfig.vPort
                trackingHost = appConfig.tHost
                trackingPort = appConfig.tPort
                liveID = appConfig.liveID
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        appConfig.vHost = chatHost
                        appConfig.vPort = chatPort
                        appConfig.tHost = trackingHost
                        appConfig.tPort = trackingPort
                        appConfig.liveID = liveID
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

//#Preview {
//    SettingView()
//        .environment(ClientState())
//}
