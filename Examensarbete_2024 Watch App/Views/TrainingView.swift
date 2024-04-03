//
//  TrainingView.swift
//  Examensarbete_2024 Watch App
//
//  Created by Ellen Carlsson on 2024-04-01.
//

import SwiftUI

struct TrainingView: View {
    var gestureViewModel = GestureViewModel()
    @State var counter = 0
    @State var isDetectingForTraining = false
    @State var isDetectingStillMotion = true
    
    var body: some View {
        
        Text("\(counter)")
            .foregroundColor(.black)
            .font(.title)
        
        if isDetectingForTraining {
            
            // detecting
            Button {
                isDetectingForTraining = false
                
                if (isDetectingStillMotion) {
                    gestureViewModel.addStillGestureToDatabase()
                } else {
                    gestureViewModel.addMovingDataToDatabase()
                }
                
                
                vibrateAppleWatch()
                counter += 1
                
            } label: {
                Image(systemName: "hand.raised.brakesignal")
                    .resizable()
                    .frame(width: 150, height: 100)
                    .symbolEffect(.bounce.up, options:  isDetectingForTraining ? .repeating : .nonRepeating,value: 0)
                    .foregroundColor(isDetectingStillMotion ? AppColors.detectingGreen : AppColors.detectingBlue)
                
            }
            .font(.largeTitle)
            .buttonStyle(PlainButtonStyle())
            
            Text("Detecting...")
                .font(.system(size: 12))
                .foregroundColor(Color.black)
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
                .padding(.top, 10)
        } else {
            
            // tap to detect
            Button {
                isDetectingForTraining = true
                
                if isDetectingStillMotion {
                    gestureViewModel.startStillMotionModel()
                } else {
                    gestureViewModel.startMovingMotionModel()
                }
                
                
            } label: {
                Image(systemName: "hand.raised.brakesignal")
                    .resizable()
                    .frame(width: 150, height: 100)
                    .symbolEffect(.bounce.up, options: .nonRepeating,value: false)
                    .foregroundColor(isDetectingStillMotion ? AppColors.noDetectingGreen : AppColors.noDetectingBlue)
            }
            .font(.largeTitle)
            .buttonStyle(PlainButtonStyle())
            
            Text("Tap to detect")
                .font(.system(size: 12))
                .foregroundColor(Color.black)
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
                .padding(.top, 10)
            
        }
        
    }
        
}

#Preview {
    TrainingView()
}
