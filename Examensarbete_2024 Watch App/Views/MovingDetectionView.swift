import SwiftUI
import AVFoundation


struct MovingDetectionView: View {
    @ObservedObject var gestureViewModel = GestureViewModel()
    let speaker = Speaker()
    
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
                                vibrateAppleWatch()
                                gestureViewModel.startMovingMotionModelWithCompletion {
                                    self.predictedWord = gestureViewModel.getPredictedWord()
                                    self.predictedWord = translate(withoutSwe: self.predictedWord)
                                    
                                    speaker.speak(self.predictedWord)
                                }
                                
                                self.countDown = 3
                                //self.isDetecting = false
                                self.clickToDetect = false
                                
                                
                            }
                        }
                } else {
                    // If predicted word is not empty, display it and a back button to restart
                    
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
                    
                    if !predictedWord.isEmpty {
                        Text("\(predictedWord)")
                            .foregroundStyle(.black)
                            .padding(.bottom, 50)
                            .padding(.top, 45)
                            .font(.title)
                            .bold()
                    }
                    
                    
                }
            } else {
                Button(action: {
                    self.clickToDetect = true
                    self.isDetecting = true
                    self.countDown = 3 // Reset the countdown
                }) {
                    Image(systemName: "hand.raised.fill")
                        .resizable()
                        .frame(width: 70, height: 105)
                        .foregroundColor(isDetecting ? AppColors.detectingPink : AppColors.nodetectingPink)
                }
                .padding()
                .font(.largeTitle)
                .padding(.bottom, 30)
                
                Text("Tap to prepare detecting a moving hand gesture")
                    .font(.system(size: 12))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
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


private func translate (withoutSwe: String) -> String {
    if withoutSwe == "forsta" {
        return "förstå"
    }
    
    if withoutSwe == "fa" {
        return "få"
    }
    
    return withoutSwe
}
