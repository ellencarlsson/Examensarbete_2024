//
//  DetectionView.swift
//  Examensarbete_2024 Watch App
//
//  Created by Ellen Carlsson on 2024-04-01.
//

import SwiftUI

struct SequenceDetectionView: View {
    var gestureViewModel = GestureViewModel()
    
    @State var isDetecting = false
    @State var word = ""
    @State var predictedLetter: String = ""
    @State var bounce = 0
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .default).autoconnect()
    let speaker = Speaker()
    
    var body: some View {
        
        VStack {
            if isDetecting {
                
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
                
                
                if predictedLetter == "" {
                    Image(systemName: "hand.raised.brakesignal")
                        .resizable()
                        .frame(width: 75, height: 50)
                        .symbolEffect(.bounce.up, options: .repeating,value: bounce)
                        .foregroundColor(AppColors.detectingRed)
                        .padding(.bottom, 65)
                        .padding(.top, 45)
                        .onReceive(timer) { _ in
                            predictedLetter = gestureViewModel.getPredictedLetter()
                            bounce += 1
                            print(word)
                        }
                    
                } else {
                    Text("\(predictedLetter)")
                        .foregroundStyle(.black)
                        .padding(.bottom, 50)
                        .padding(.top, 45)
                        .font(.title)
                        .bold()
                        .onAppear(perform: {
                            vibrateAppleWatch()
                            //speaker.speak(predictedLetter)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                word += predictedLetter
                                predictedLetter = ""
                            }
                        })
                    
                }
                
                Text("\(word)")
                    .foregroundColor(.black)
                    .padding(.bottom, 5)
                    .font(.system(size: 20))
                
            } else {
                
                // tap to detect screen
                Button {
                    gestureViewModel.startStillMotionModel()
                    predictedLetter = gestureViewModel.getPredictedLetter()
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
