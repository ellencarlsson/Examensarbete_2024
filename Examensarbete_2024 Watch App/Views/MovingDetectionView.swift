import SwiftUI
import AVFoundation


class SpeechService {
    private let synthesizer = AVSpeechSynthesizer()
    
    func speak(_ phrase: String) {
        let utterance = AVSpeechUtterance(string: phrase)
        utterance.voice = AVSpeechSynthesisVoice(language: "sv-SE")
        synthesizer.speak(utterance)
    }
}

struct MovingDetectionView: View {
    @ObservedObject var gestureViewModel = GestureViewModel()
    let speechService = SpeechService()
    
    @State var isDetecting = false
    @State var predictedWord: String = ""
    @State var clickToDetect = false
    @State var countDown = 3
    
    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    
    var body: some View {
        VStack {
            if isDetecting {
                if clickToDetect {
                    Text("\(countDown)")
                        .foregroundColor(AppColors.detectingPink)
                        .font(.title)
                        .onReceive(timer) { _ in
                            if self.countDown > 0 {
                                self.countDown -= 1
                            }
                            if self.countDown == 0 {
                                gestureViewModel.startMovingMotionModel()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                    self.predictedWord = gestureViewModel.getPredictedWord()
                                    gestureViewModel.stopMovingMotionModel()
                                    self.isDetecting = false
                                    self.clickToDetect = false
                                    
                                    // Speak the predicted word
                                    if !self.predictedWord.isEmpty {
                                            self.speechService.speak(self.predictedWord)
                                    }
                                }
                            }
                        }
                } else {
                    // If predicted word is not empty, display it and a back button to restart
                    if !predictedWord.isEmpty {
                        Text("\(predictedWord)")
                            .foregroundStyle(.black)
                            .padding(.bottom, 50)
                            .padding(.top, 45)
                            .font(.title)
                            .bold()
                    }
                    
                    Button(action: {
                        isDetecting = false
                        clickToDetect = false
                    }) {
                        Image(systemName: "arrow.backward.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
                    }
                    .padding(-16)
                    .padding(.trailing, 100)
                }
            } else {
                Button(action: {
                    self.clickToDetect = true
                    self.isDetecting = true
                    self.countDown = 3 // Reset the countdown
                }) {
                    Image(systemName: "hand.raised.fill")
                        .resizable()
                        .frame(width: 105, height: 70)
                        .foregroundColor(isDetecting ? AppColors.detectingPink : AppColors.nodetectingPink)
                }
                .padding()
                .font(.largeTitle)
                
                Text("Tap to prepare detecting a moving hand gesture")
                    .font(.system(size: 12))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color.white)
    }
}

struct MovingDetectionView_Previews: PreviewProvider {
    static var previews: some View {
        MovingDetectionView()
    }
}
