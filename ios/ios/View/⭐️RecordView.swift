import SwiftUI


struct RecordView: View {
    @State var speechRecognizer = SpeechRecognizer()
    @State private var isRecording: Bool = false
    @State private var text = ""
    var body: some View {
        
        VStack {
//            Image(systemName: "waveform")
//                .font(.system(size: 40))
//                .frame(width: 50, height: 50)
//                .glassEffect(.clear.interactive())
//                .onTapGesture {
//                    print("start transcription")
//                    speechRecognizer.resetTranscript()
//                    speechRecognizer.startTranscribing()
//                    isRecording = true
//                }
            Button("Start") {
                print("start transcription")
                speechRecognizer.resetTranscript()
                speechRecognizer.startTranscribing()
                isRecording = true
            }
            .padding(30)
            .glassEffect(.clear.interactive(), in: .circle)
            
            
            Button("end transcription") {
                speechRecognizer.stopTranscribing()
                print("ended transcription")
                print("text is", speechRecognizer.transcript)
                isRecording = false
            }
            .padding()
            .glassEffect()
            .cornerRadius(30)
        }.onAppear{
            text = speechRecognizer.transcript
        }
    }
}


#Preview {
    RecordView()
}

