import SwiftUI

struct RecordView: View {
    var appConf: AppConfig
    private let pipeline = AppPipelines()

    @State private var clientState: ClientState?
    @State private var audioState = AudioState()

    @State private var isRecording: Bool = false
    @State private var text = ""

    func setUpClient() {
        self.clientState = ClientState(
            config: appConf,
            processedTextRx: pipeline.processedTextRx
        )
    }

    var body: some View {
        VStack {
            if let clientState {
                ScrollView {
                    ForEach(clientState.responses, id: \.description) { resp in
                        Text(resp)
                    }
                }
            }

            if audioState.isReady {
                Button(audioState.isRecording ? "Stop" : "Start") {
                    if audioState.isRecording {
                        // stop処理が必要ならここに (TODO)
                        print("Stop not implemented yet")
                    } else {
                        // 呼び出すだけ！ await不要
                        setUpClient()
                        Task {
                            await self.clientState?.startClient()
                        }
                        Task {
                            try? audioState.start()
                        }

                        print("ボタン処理終了")
                    }
                }
                .padding(30)
                .glassEffect(.clear.interactive(), in: .circle)
            } else {
                ProgressView("preparing or error")
            }
        }
        .task {
            await audioState.setupSession(
                processedAudioRx: pipeline.processedAudioRx,
                processedAudioTx: pipeline.processedAudioTx,
                processedTextRx: pipeline.processedTextRx,
                processedTextTx: pipeline.processedTextTx
            )
        }
    }
}

//#Preview {
//    RecordView(appConfig: <#T##AppConfig#>, clientState: <#T##ClientState#>)
//}
