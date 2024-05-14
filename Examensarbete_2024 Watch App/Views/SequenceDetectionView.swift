//
//  DetectionView.swift
//  Examensarbete_2024 Watch App
//
//  Created by Ellen Carlsson on 2024-04-01.
//

import SwiftUI

struct SequenceDetectionView: View {
    var gestureViewModel = GestureViewModel()
    
    @State private var counter = 3
    @State var isDetecting = false
    @State var word = ""
    @State var predictedLetter: String = ""
    @State var bounce = 0
    @State var prob = 0.0
    @State var fixedWord = ""
    @State var countDown = 3
    @State var clickToDetect = false
    
    let countDownTimer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    let timer = Timer.publish(every: 0.00001, on: .main, in: .default).autoconnect()
    let speaker = Speaker()
    @State private var timeDetector = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    
    
    
    var body: some View {
        
        VStack {
            if isDetecting {
                if clickToDetect {
                    Text("\(countDown)")
                        .foregroundColor(AppColors.detectingPurpule)
                        .font(.title)
                        .onReceive(countDownTimer) { _ in
                            if self.countDown > 0 {
                                self.countDown -= 1
                            }
                            
                            if countDown == 0 {
                                gestureViewModel.startStillMotionModel()
                                vibrateAppleWatch()
                                predictedLetter = gestureViewModel.getPredictedLetterAndProb().0
                                countDown = 3
                                clickToDetect = false
                                
                            }
                        }
                    
                } else {
                    VStack {
                        // detection screen
                        Button(action: {
                            isDetecting = false
                            bounce = 0
                            
                            print(word)
                            word = ""
                            
                        }) {
                            Image(systemName: "arrow.backward.circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.black)
                        }
                        .padding(-16)
                        .padding(.trailing, 100)
                        
                        
                        if predictedLetter == "" {
                            Image(systemName: "hand.raised.brakesignal")
                                .resizable()
                                .frame(width: 75, height: 50)
                                .symbolEffect(.bounce.up, options: .repeating,value: bounce)
                                .foregroundColor(AppColors.detectingRed)
                                .padding(.bottom, 65)
                                .padding(.top, 45)
                                .onReceive(timer) { _ in
                                    predictedLetter = gestureViewModel.getPredictedLetterAndProb().0
                                    prob = gestureViewModel.getPredictedLetterAndProb().1
                                    bounce += 1
                                    //print(word)
                                }
                            
                            
                        } else {
                            Text("\(predictedLetter)")
                                .foregroundStyle(.black)
                                .padding(.bottom, 50)
                                .padding(.top, 45)
                                .font(.title)
                                .bold()
                                .onAppear(perform: {
                                    
                                    //speaker.speak(predictedLetter)
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                                        word += predictedLetter
                                        if prob > 0.75 {
                                            fixedWord += predictedLetter
                                        }
                                        predictedLetter = ""
                                    }
                                })
                            
                        }
                        
                        Text("\(word)")
                            .foregroundColor(.black)
                            .padding(.bottom, 5)
                            .font(.system(size: 20))
                    }
                    .onReceive(timeDetector, perform: { _ in
                        
                        if counter > 0 {
                            counter -= 1
                        } else {
                            
                            print("har gått 2 sekunder")
                            isDetecting = false
                            counter = 3
                            word = ""
                            fixedWord = ""
                            
                        }
                        if counter != 3{
                            vibrateAppleWatch()
                            
                            print("\(word.count)" + ":   " + word + " ---- " + fixedWord)
                            word = ""
                            fixedWord = ""
                            
                        }
                        
                    })
                }
                
                
                
                
                
            } else {
                
                // tap to detect screen
                Button {
                    countDown = 3
                    clickToDetect = true
                    isDetecting = true
                    
                    
                } label: {
                    Image(systemName: "hand.raised.brakesignal")
                        .resizable()
                        .frame(width: 105, height: 70)
                        .symbolEffect(.bounce.up, options: .nonRepeating,value: predictedLetter)
                        .foregroundColor(isDetecting ? AppColors.detectingRed : AppColors.noDetectingRed)
                }
                .font(.largeTitle)
                .buttonStyle(PlainButtonStyle())
                .padding(20)
                
                
                Text("Tap to detect hand")
                    .font(.system(size: 12))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                
                Text("sequence gestures")
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

#Preview {
    SequenceDetectionView()
}
