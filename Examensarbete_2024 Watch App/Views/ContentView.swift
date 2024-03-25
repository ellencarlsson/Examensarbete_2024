//
//  ContentView.swift
//  Examensarbete_2024 Watch App
//
//  Created by Ellen Carlsson on 2024-01-05.
//

import SwiftUI

struct ContentView: View {
    @State private var isDetecting = false //temporär variabel bara
    let motionViewModel = MotionViewModel()
    let databaseViewModel = DatabaseViewModel()
    
    var body: some View {
        VStack {
            
            if isDetecting == true {
                
                Button {
                    isDetecting = false
                    motionViewModel.stopMotionModel()
                    print("Stopping detection")
                    
                } label: {
                    Image(systemName: "hand.raised.brakesignal")
                        .frame(width: 42, height: 42)
                        .symbolEffect(.bounce.up, options:  isDetecting ? .repeating : .nonRepeating,value: 0)
                        .foregroundColor(isDetecting ? AppColors.detectingGesturesRed : AppColors.noDetectingGesturesRed)
                    
                }
                .font(.largeTitle)
                .buttonStyle(PlainButtonStyle())
                
                Text("Detecting...")
                    .font(.system(size: 12))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
            }
            
            if isDetecting == false {
                
                Button {
                    isDetecting = true
                    motionViewModel.startMotionModel()
                    print("Starting detection")
                } label: {
                    Image(systemName: "hand.raised.brakesignal")
                        .frame(width: 42, height: 42)
                        .symbolEffect(.bounce.up, options: .nonRepeating,value: false)
                        .foregroundColor(isDetecting ? AppColors.detectingGesturesRed : AppColors.noDetectingGesturesRed)
                }
                .font(.largeTitle)
                .buttonStyle(PlainButtonStyle())
                
                Text("Tap to detect hand gestures")
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
    ContentView()
}
