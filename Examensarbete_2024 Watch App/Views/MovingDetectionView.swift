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
    @State var predictedWord: String = ""
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
                                    gestureViewModel.startMovingMotionModel()
                                    
                                    countDown = 3
                                    vibrateAppleWatch()
                                    speaker.speak(predictedWord)
                                    timer.invalidate()
                                    clickToDetect = false
                                }
                            }
                        }
                    
                } else {
                    // detection screen
                    Button(action: {
                        isDetecting = false
                        bounce = 0
                        word = ""
                        
                    }) {
                        Image(systemName: "arrow.backward.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
                    }
                    .padding(-16)
                    .padding(.trailing, 100)
                    
                    Text("\(predictedWord)")
                        .foregroundStyle(.black)
                        .padding(.bottom, 50)
                        .padding(.top, 45)
                        .font(.title)
                        .bold()
                        .onAppear() {
                            //predictedWord = gestureViewModel.getPredictedWord()
                        }
                    
                    
                    
                    
                    Text("\(word)")
                        .foregroundColor(.black)
                        .padding(.bottom, 5)
                        .font(.system(size: 20))
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
}

#Preview {
    MovingDetectionView()
}
