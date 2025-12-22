import SwiftUI

struct ContentView: View {
    @Environment(AppConfig.self) var appConfig
    
    
    @State private var selectedTab: HomeTab = .record
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Record", systemImage: "waveform.circle.fill", value: .record) {
                RecordView(appConf: appConfig, )
                    
            }
            Tab("Comments", systemImage: "bubble.left.and.bubble.right.fill", value: .comments) {
                Text("coming soon...")
            }
            Tab("Tracking", systemImage: "faceid", value: .tracking) {
                Text("Coming Soon")
            }
            Tab("Settings", systemImage: "gear", value: .settings, role: .search) {
                SettingView()
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

//#Preview {
//    ContentView()
//        .environment(AppConfig())
//}
