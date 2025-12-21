import SwiftUI

struct RecordView: View {
    @State private var audioState = AudioState()

    @State private var isRecording: Bool = false
    @State private var text = ""
    var body: some View {
        VStack {
            if audioState.isReady {
                Button(audioState.isRecording ? "Stop" : "Start") {
                    if audioState.isRecording {
                        // stop処理が必要ならここに (TODO)
                        print("Stop not implemented yet")
                    } else {
                        // 呼び出すだけ！ await不要
                        try? audioState.start()
                    }
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
