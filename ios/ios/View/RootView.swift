import SwiftUI

struct RootView: View {
    @Environment(ClientState.self) var clientState
    var body: some View {
        NavigationStack {
            ConnectionView()
                .navigationDestination(
                    isPresented: .constant(clientState.connectClient != nil)
                ) {
                    ChatView()
                }
        }
    }
}

#Preview {
    RootView()
        .environment(ClientState())
}
