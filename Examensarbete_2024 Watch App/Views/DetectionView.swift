//
//  DetectionView.swift
//  Examensarbete_2024 Watch App
//
//  Created by Ellen Carlsson on 2024-04-01.
//

import SwiftUI

struct DetectionView: View {
    var gestureViewModel = GestureViewModel()
    
    @State var isDetecting = false
    @State var word = ""
    @State var predictedLetter: String = ""
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .default).autoconnect()
    let speaker = Speaker()
    
    var body: some View {
        
        if isDetecting {
            
            // detection screen
            Button(action: {
                isDetecting = false
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
                    .frame(width: 60, height: 40)
                    .symbolEffect(.bounce.up, options: .nonRepeating,value: predictedLetter)
                    .foregroundColor(AppColors.detectingGesturesRed)
                    .padding(.bottom, 65)
                    .padding(.top, 45)
                    .onReceive(timer) { _ in
                        predictedLetter = gestureViewModel.getPredictedLetter()
                        
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
                        speaker.speak(predictedLetter)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
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
                    .symbolEffect(.bounce.up, options: .nonRepeating,value: false)
                    .foregroundColor(isDetecting ? AppColors.detectingGesturesRed : AppColors.noDetectingGesturesRed)
            }
            .font(.largeTitle)
            .buttonStyle(PlainButtonStyle())
            .padding(20)
            
            
            Text("Tap to detect hand")
                .font(.system(size: 12))
                .foregroundColor(Color.black)
                .multilineTextAlignment(.center)
            
            Text("gestures")
                .font(.system(size: 12))
                .foregroundColor(Color.black)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    DetectionView()
}
