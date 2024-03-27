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

    func getCurrentMotion() -> MotionData{
        return motionModel.getCurrentMotion()
    }
    
    func addMotionDataToDatabase () {
        motionModel.stopMotionUpdatess()
        let motiondata = getCurrentMotion()
        databaseViewModel.addDataToDatabase(motionData: motiondata)
    }
    
    func getPredictedLetter() -> String {
        let currentMotion = getCurrentMotion()
        let prediction = testModel.testModel(incommingMotionData: currentMotion)
        
        if (prediction!.targetProbability["\(prediction!.___letter)"]) != nil {
            if prediction!.targetProbability["\(prediction!.___letter)"]! > 0.75 {
                //print("är högre: " + "\(prediction!.targetProbability["\(prediction!.___letter)"])")
                
                let predictedLetter: String = prediction!.___letter
                return predictedLetter
                
            } else {
                //print("är lägre: " + "\(prediction!.targetProbability["\(prediction!.___letter)"])")
                
                return ""
            }
        }
        return ""
    }
    
}
