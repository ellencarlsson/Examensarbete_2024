//
//  MotionViewModel.swift
//  Examensarbete_2024 Watch App
//
//  Created by Ellen Carlsson on 2024-01-05.
//

import Foundation

class GestureViewModel {
    let motionModel = MotionModel()
    let testModel = TestModel()
    let databaseViewModel = DatabaseViewModel()
    
    func startMotionModel(){
        motionModel.startMotionUpdates()
    }
    
    func stopMotionModel(){
        motionModel.stopMotionUpdates()
    }
    
    func getCurrentMotion() -> MotionData{
        return motionModel.getCurrentMotion()
    }
    
    func addMotionDataToDatabase () {
        motionModel.stopMotionUpdatess()
        let motiondata = getCurrentMotion()
        databaseViewModel.addDataToDatabase(motionData: motiondata)
    }
    
    func getPredictedLetter() -> HandSignDetection1Output {
        let currentMotion = getCurrentMotion()
        let prediction = testModel.testModel()!
        return prediction
    }
    
}
