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
    @State var isDetectingStillMotion = false
    @State var showCountDown = false
    @State var countDown = 3
    
    var body: some View {
        
        VStack {
            
            if !showCountDown {
                Text("\(counter)")
                    .foregroundColor(.black)
                    .font(.title)
            }
            
            
            if isDetectingForTraining && showCountDown == false{
                
                
                if isDetectingStillMotion {
                    Button {

                        isDetectingForTraining = false
                        gestureViewModel.addStillGestureToDatabase()
 
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
                } else {
                    Image(systemName: "hand.raised.brakesignal")
                        .resizable()
                        .frame(width: 150, height: 100)
                        .symbolEffect(.bounce.up, options:  isDetectingForTraining ? .repeating : .nonRepeating,value: 0)
                        .foregroundColor(isDetectingStillMotion ? AppColors.detectingGreen : AppColors.detectingBlue)
                        .onAppear(){
                            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                                if self.counter > 1 {
                                    self.counter -= 1
                                } else {
                                    timer.invalidate()
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                        gestureViewModel.addMovingDataToDatabase()
                                        print("nu har det gått 0.6 sekunder")
                                        isDetectingForTraining = false
                                        counter += 1
                                    }
                                }
                            }
                        }
                }
                // detecting

                Text("Detecting...")
                    .font(.system(size: 12))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)
                    .padding(.top, 10)
                
            } else if isDetectingForTraining == false && showCountDown == false {
                
                // tap to detect
                Button {
                    
                    
                    if isDetectingStillMotion {
                        isDetectingForTraining = true
                        gestureViewModel.startStillMotionModel()
                    } else {
                        showCountDown = true
                        //gestureViewModel.startMovingMotionModel()
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
                
            } else if showCountDown {
                Text("\(countDown)")
                    .foregroundColor(AppColors.detectingBlue)
                    .font(.title)
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                            if self.countDown > 1 {
                                self.countDown -= 1
                            } else {
                                print("slut")
                                showCountDown = false
                                isDetectingForTraining = true
                                countDown = 3
                                gestureViewModel.startMovingMotionModel()
                                timer.invalidate()
                            }
                        }
                    }
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        
    }
}

#Preview {
    TrainingView()
}
