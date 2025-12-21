import SwiftUI

struct ContentView: View {
    @Environment(ClientState.self) var clientState: ClientState
    @State private var selectedTab: HomeTab = .record
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Record", systemImage: "waveform.circle.fill", value: .record) {
                RecordView()
            }
            Tab("Comments", systemImage: "bubble.left.and.bubble.right.fill", value: .comments) {
                Text("coming soon...")
            }
            Tab("Tracking", systemImage: "faceid", value: .tracking) {
                Text("Coming Soon")
            }
            Tab("Settings", systemImage: "gear", value: .settings, role: .search) {
                SettingView()
                    .environment(clientState)
            }
        }
    }
}

enum HomeTab: Hashable {
    case record
    case comments
    case tracking
    case settings
}

#Preview {
    ContentView()
        .environment(ClientState())
}
