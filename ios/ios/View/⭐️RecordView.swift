import SwiftUI

struct RecordView: View {
    @State private var audioState = AudioState()

    @State private var isRecording: Bool = false
    @State private var text = ""
    var body: some View {
        VStack {
            if audioState.isReady {
                Button("Start") {
                    print("start transcription")
                    audioState
                }
                .padding(30)
                .glassEffect(.clear.interactive(), in: .circle)
            } else {
                ProgressView("preparing or error")
            }
        }
        .task {
            await audioState.setupSession()
        }
    }
}

#Preview {
    RecordView()
}
