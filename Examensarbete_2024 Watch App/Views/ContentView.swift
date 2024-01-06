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
    
    var body: some View {
        VStack {
            
            if isDetecting == false {
                Button {
                    motionViewModel.startMotionModel()
                    isDetecting = true
                    
                } label: {
                    Image(systemName: "hand.raised.brakesignal")
                        .frame(width: 42, height: 42)
                        .foregroundColor(AppColors.noDetectingGesturesRed)
                        .symbolEffect(.bounce, value: 5)
                }
                .font(.largeTitle)
                .buttonStyle(PlainButtonStyle())
            } else {
                Button {
                    motionViewModel.stopMotionModel()
                    isDetecting = false
                    
                    print("hej")
                } label: {
                    Image(systemName: "hand.raised.brakesignal")
                        .frame(width: 42, height: 42)
                        .foregroundColor(AppColors.detectingGesturesRed)
                        .symbolEffect(.bounce, value: 2) // denna funkar inte...
                }
                .symbolEffect(.bounce, value: 5)
                .font(.largeTitle)
                .buttonStyle(PlainButtonStyle())
            }
            
        
            Text("Tap to detect hand gestures")
                .font(.system(size: 12))
                .foregroundColor(Color.black)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(AppColors.backgroundBeige)
        
        
    }
    
}

#Preview {
    ContentView()
}
