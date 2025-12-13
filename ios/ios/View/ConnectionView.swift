import SwiftUI
import Connect

struct ConnectionView: View {
    @Environment(ClientState.self) var clientState
    @State private var host = ""
    @State private var port = ""

    var body: some View {
        VStack {
            Image("001")
                .resizable()
                .clipShape(Circle())
                .background(Circle().fill(.white))
                .frame(width: 250, height: 250)

            Spacer()
            TextField("ip addr", text: $host)
                .padding(12)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .font(.system(size: 40, weight: .light, design: .default))
            TextField("port", text: $port)
                .padding(12)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .font(.system(size: 40, weight: .light, design: .default))
            Spacer()
            Button("connect") {
                clientState.createClient(host: host, port: port)
            }
            .font(.title)
            .padding()
            .glassEffect()

        }
        .padding()
        .background(Color(red: 1, green: 1, blue: 0.1, opacity: 0.5))

    }
    
}



#Preview {
    ConnectionView()
        .environment(ClientState())
}
