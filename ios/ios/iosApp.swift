import SwiftUI

@main
struct iosApp: App {
    @State private var clientState = ClientState()
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(clientState)
        }
    }
}
