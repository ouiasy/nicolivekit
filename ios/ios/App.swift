import SwiftUI

@main
struct AppRoot: App {
    var appConfig = AppConfig.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appConfig)
        }
    }
}
