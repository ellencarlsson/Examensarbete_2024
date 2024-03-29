//
//  ContentView.swift
//  Examensarbete_2024 Watch App
//
//  Created by Ellen Carlsson on 2024-01-05.
//

import SwiftUI

struct ContentView: View {
    @State private var isDetectingForTraining = false
    @StateObject var gestureViewModel = GestureViewModel()
    let databaseViewModel = DatabaseViewModel()
    let speaker = Speaker()
    
    @State var trainingMode = false // Change here to train/real app
    
    @State var counter = 0
    
    @State var isDetecting = false
    
    @State var predictedLetter: String = ""
    
    @State var word = ""
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .default).autoconnect()
    
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
                        gestureViewModel.startMotionModel()
                        predictedLetter = gestureViewModel.getPredictedLetter()
                        
                        isDetecting = true
                        print("Starting detection")
                        
                        
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

