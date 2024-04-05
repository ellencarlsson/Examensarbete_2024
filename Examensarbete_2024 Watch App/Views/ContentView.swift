//
//  ContentView.swift
//  Examensarbete_2024 Watch App
//
//  Created by Ellen Carlsson on 2024-01-05.
//

import SwiftUI

import WatchKit

func vibrateAppleWatch() {
    WKInterfaceDevice.current().play(.notification)
}

struct ContentView: View {
    
    @State private var trainingMode = false // Change here to train/real app
    @State private var stillDetection = false
    @State private var sequenceDetection = false
    @State private var movingDetection = true
    
    //private let gestureViewModel = GestureViewModel()
    
    var body: some View {
        
        VStack {
            if trainingMode {
    
                TrainingView()
                
            } else {
                
                if stillDetection {
                    StillDetectionView()
                    
                } else if sequenceDetection {
                    SequenceDetectionView()
                    
                } else if movingDetection {
                    MovingDetectionView()
                    
                } else {
                    
                    Text("no mode selected")
                        .font(.system(size: 12))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                }
            }
            
            /*Button(action: {
                gestureViewModel.detectMovingMotion()
            }, label: {
                /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
                    .foregroundColor(.blue)
            })*/
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color.white)
    }
}

#Preview {
    ContentView()
}

