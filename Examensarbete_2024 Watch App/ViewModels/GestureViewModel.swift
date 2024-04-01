//
//  MotionViewModel.swift
//  Examensarbete_2024 Watch App
//
//  Created by Ellen Carlsson on 2024-01-05.
//

import Foundation

class GestureViewModel: ObservableObject {
    let stillMotionModel = StillMotionModel()
    let testModel = TestModel()
    let databaseViewModel = DatabaseViewModel()
    let movingMotionModel = MovingMotionModel()
    
    func startStillMotionModel(){
        stillMotionModel.startMotionUpdates()
    }
    
    private func stopMotionModel() {
        stillMotionModel.stopMotionUpdates()
    }
    
    
    func getCurrentStillMotion() -> StillMotionData{
        return stillMotionModel.motionData
    }
    
    func addStillGestureToDatabase () {
        stillMotionModel.stopMotionUpdates()
        let stillMotionData = getCurrentStillMotion()
        databaseViewModel.addStillDataToDatabase(stillMotionData: stillMotionData)
    }
    
    func startMovingMotionModel () {
        movingMotionModel.startMotionUpdates()
    }
    
    func addMovingDataToDatabase () {
        movingMotionModel.stopMotionUpdates()
        let movingMotionData = movingMotionModel.getMovingMotionData()
        databaseViewModel.addMovingDataToDatabase(movingMotionData: movingMotionData)
    }
    
    func getPredictedLetter() -> String {
        let currentMotion = getCurrentStillMotion()
        let prediction = testModel.testModel(incommingMotionData: currentMotion)
        
        /*if (prediction!.targetProbability["\(prediction!.___letter)"]) != nil {
            if prediction!.targetProbability["\(prediction!.___letter)"]! > 0.75 {
                print("är högre: " + "\(prediction!.targetProbability["\(prediction!.___letter)"])")
                
                let predictedLetter: String = prediction!.___letter
                return predictedLetter
                
            } else {
                print("är lägre: " + "\(prediction!.targetProbability["\(prediction!.___letter)"])")
                
                return ""
            }
        }*/
        
        if (prediction!.___letterProbability["\(prediction!.___letter)"]) != nil {
            if prediction!.___letterProbability["\(prediction!.___letter)"]! > 0.75 {
                //print("är högre: " + "\(prediction!.___letterProbability["\(prediction!.___letter)"])")
                
                let predictedLetter: String = prediction!.___letter
                return predictedLetter
                
            } else {
                //print("är lägre: " + "\(prediction!.___letterProbability["\(prediction!.___letter)"])")
                
                return ""
            }
        }
        
        return ""
    }
    
}
