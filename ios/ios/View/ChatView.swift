import SwiftUI

struct ChatView: View {
    @Environment(ClientState.self) var clientState
    @State private var text: String = ""
    @State private var messages: [String] = []

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        ForEach(messages.indices, id: \.self) { i in
                            Text(messages[i])
                                .padding(10)
                                .background(.ultraThinMaterial)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 12)
                                )
                                .id(i)
                        }
                    }
                    .padding()
                }.onChange(of: messages.count) {
                    withAnimation {
                        proxy.scrollTo(messages.count - 1, anchor: .bottom)
                    }
                }
            }

            HStack {
                TextField("input", text: $text)
                    .textFieldStyle(.roundedBorder)

                Button("send") {
                    let sendingText = text
                    text = ""
                    Task { @MainActor in
                        if let resp = await clientState.send(text: sendingText) {
                            messages.append(resp)
                        } else {
                            messages.append("failed")
                        }
                    }
                }
            }
            .padding()
        }
    }

}

#Preview {
    ChatView()
        .environment(ClientState())
}
