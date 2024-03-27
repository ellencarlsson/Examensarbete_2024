//
//  ContentView.swift
//  Examensarbete_2024 Watch App
//
//  Created by Ellen Carlsson on 2024-01-05.
//

import SwiftUI

struct ContentView: View {
    @State private var isDetectingForTraining = false
    let gestureViewModel = GestureViewModel()
    let databaseViewModel = DatabaseViewModel()
    
    @State var trainingMode = false // Change here to train/real app
    
    @State var counter = 0
    
    @State var isDetecting = false
    
    var body: some View {
        VStack {
            if trainingMode {
                Text("\(counter)")
                    .foregroundColor(.black)
                    .font(.title)
                
                if isDetectingForTraining == true {
                    
                    // detecting in training
                    Button {
                        isDetectingForTraining = false
                        gestureViewModel.addMotionDataToDatabase()
                        print("Stopping detection")
                        counter += 1
                        
                    } label: {
                        Image(systemName: "hand.raised.brakesignal")
                            .resizable()
                            .frame(width: 150, height: 100)
                            .symbolEffect(.bounce.up, options:  isDetectingForTraining ? .repeating : .nonRepeating,value: 0)
                            .foregroundColor(isDetectingForTraining ? AppColors.detectingGesturesRed : AppColors.noDetectingGesturesRed)
                        
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
                    
                    // tap to detect in training
                    Button {
                        isDetectingForTraining = true
                        gestureViewModel.startMotionModel()
                        print("Starting detection")
                    } label: {
                        Image(systemName: "hand.raised.brakesignal")
                            .resizable()
                            .frame(width: 150, height: 100)
                            .symbolEffect(.bounce.up, options: .nonRepeating,value: false)
                            .foregroundColor(AppColors.noDetectingGesturesRed)
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
                
            } else {
                
                if isDetecting {
                    
                    // detection screen
                    Button(action: {
                        isDetecting = false
                    }) {
                        Image(systemName: "arrow.backward.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
                    }
                    .padding(-16)
                    .padding(.trailing, 100)
                    
                    Text("\(gestureViewModel.getPredictedLetter().___letter)")
                        .foregroundStyle(.black)
                        .padding(.bottom, 50)
                        .padding(.top, 45)
                        .font(.title)
                        .bold()
                    
                    Text("Word")
                        .foregroundColor(.black)
                        .padding(.bottom, 5)
                        .font(.system(size: 20))
                    
                } else {
                    
                    // tap to detect screen
                    Button {
                        isDetecting = true
                        print("Starting detection")
                        gestureViewModel.startMotionModel()
                        
                    } label: {
                        Image(systemName: "hand.raised.brakesignal")
                            .resizable()
                            .frame(width: 105, height: 70)
                            .symbolEffect(.bounce.up, options: .nonRepeating,value: false)
                            .foregroundColor(isDetectingForTraining ? AppColors.detectingGesturesRed : AppColors.noDetectingGesturesRed)
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color.white)
    }
}

#Preview {
    ContentView()
}

