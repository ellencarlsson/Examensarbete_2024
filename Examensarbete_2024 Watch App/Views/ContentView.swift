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
    @State private var test = 0
    
    @State private var isFavorite = false
    
    var body: some View {
        VStack {
            
            Button {
                
                
                if isDetecting == false{
                    isDetecting = true
                    motionViewModel.startMotionModel()
                    print("börjar detect")
                    
                } else {
                    isDetecting = false
                    motionViewModel.stopMotionModel()
                    print("slutar detect")
                    
                }
                
                
            } label: {
                Image(systemName: "hand.raised.brakesignal")
                    .frame(width: 42, height: 42)
                    .symbolEffect(.bounce.up, options:  isDetecting ? .repeating : .nonRepeating,value: isDetecting)
                    .foregroundColor(isDetecting ? AppColors.detectingGesturesRed : AppColors.noDetectingGesturesRed)
                    
            }
            .font(.largeTitle)
            .buttonStyle(PlainButtonStyle())
            
            if isDetecting == false {
                Text("Tap to detect hand gestures")
                    .font(.system(size: 12))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(AppColors.backgroundBeige)
        
        
    }
    
}

#Preview {
    ContentView()
}
