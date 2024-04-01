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
    
    @State private var trainingMode = true // Change here to train/real app
    
    var body: some View {
        
        VStack {
            if trainingMode {
    
                TrainingView()
                
            } else {
                
                DetectionView()
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

