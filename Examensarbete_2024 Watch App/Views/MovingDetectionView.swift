//
//  MovingDetectionView.swift
//  Examensarbete_2024 Watch App
//
//  Created by Ellen Carlsson on 2024-04-05.
//

import SwiftUI

struct MovingDetectionView: View {
    var gestureViewModel = GestureViewModel()
    
    @State var isDetecting = false
    @State var word = ""
    @State private var predictedWord: String?
    @State private var isLoading = false
    @State var bounce = 0
    @State var clickToDetect = false
    @State var countDown = 3
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .default).autoconnect()
    let speaker = Speaker()
    
    var body: some View {
        
        VStack {
            if isDetecting {
                
                if clickToDetect {
                    
                    
                    Text("\(countDown)")
                        .foregroundColor(AppColors.detectingPink)
                        .font(.title)
                        .onAppear {
                            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                                if self.countDown > 1 {
                                    self.countDown -= 1
                                } else {
                                    
                                    getPrediction()
                                    countDown = 3
                                    vibrateAppleWatch()
                                    //speaker.speak("fitta")
                                    timer.invalidate()
                                    clickToDetect = false
                                }
                            }
                        }
                    
                } else {
    
                    if self.predictedWord != nil {
                        
                        Text("\(self.predictedWord)")
                            .foregroundColor(.black)
                            .padding(.bottom, 5)
                            .font(.system(size: 20))
                            .onAppear() {
                                if self.predictedWord != nil {
                                    let hej: String = self.predictedWord!
                                    print(hej)
                                    speaker.speak(self.predictedWord!)
                                }
                            }
                    }
                        
                    
                    
                   
                }
                
            } else {
                
                // tap to detect screen
                Button {
                    //gestureViewModel.startMovingMotionModel()
                    clickToDetect = true
                    
                    isDetecting = true
                    
                } label: {
                    Image(systemName: "hand.raised.brakesignal")
                        .resizable()
                        .frame(width: 105, height: 70)
                        .symbolEffect(.bounce.up, options: .nonRepeating,value: predictedWord)
                        .foregroundColor(isDetecting ? AppColors.detectingPink : AppColors.nodetectingPink)
                }
                .font(.largeTitle)
                .buttonStyle(PlainButtonStyle())
                .padding(20)
                
                
                Text("Tap to prepare detecting a")
                    .font(.system(size: 12))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                
                Text("moving hand gesture")
                    .font(.system(size: 12))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color.white)
        
        
    }
    
    private func getPrediction() {
        isLoading = true
        predictedWord = nil // Reset the predicted word
        
        gestureViewModel.getPredictedWord { word in
            DispatchQueue.main.async {
                self.predictedWord = word
                self.isLoading = false
            }
        }
    }
}

#Preview {
    MovingDetectionView()
}

