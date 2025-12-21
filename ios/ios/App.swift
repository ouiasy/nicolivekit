import SwiftUI

@main
struct AppRoot: App {
    @State private var clientState = ClientState()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(clientState)
        }
    }
}
