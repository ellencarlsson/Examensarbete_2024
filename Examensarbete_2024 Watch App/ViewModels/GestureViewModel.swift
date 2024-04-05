//
//  MotionViewModel.swift
//  Examensarbete_2024 Watch App
//
//  Created by Ellen Carlsson on 2024-01-05.
//

import Foundation

class GestureViewModel: ObservableObject {
    let stillMotionModel = StillMotionModel()
    let testModel = MotionDetectionModel()
    let databaseViewModel = DatabaseViewModel()
    let movingMotionModel = MovingMotionModel()
        
    func startStillMotionModel(){
        stillMotionModel.startMotionUpdates()
    }
    
    private func stopMotionModel() {
        stillMotionModel.stopMotionUpdates()
    }
    
    func stopMovingMotionModel () {
        movingMotionModel.stopMotionUpdates()
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
        movingMotionModel.resetTimeAndArray()
    }
    
    func getPredictedWord () -> String {
        let movingMotionData = movingMotionModel.getMovingMotionData()
        print(movingMotionData)
        let prediction = testModel.movingMotionDetector(movingMotionData: movingMotionData)
        
        if (prediction!.labelProbability["\(prediction!.label)"]) != nil {
            if prediction!.labelProbability["\(prediction!.label)"]! > 0.60 {
                //print("är högre: " + "\(prediction!.___letterProbability["\(prediction!.___letter)"])")
                
                let predictedLetter: String = prediction!.label
                return predictedLetter
                
            } else {
                //print("är lägre: " + "\(prediction!.___letterProbability["\(prediction!.___letter)"])")
                
                return ""
            }
        }
        
        return ""
    }
    
    func getPredictedLetter() -> String {
        let currentMotion = getCurrentStillMotion()
        let prediction = testModel.stillMotionDetecter(incommingMotionData: currentMotion)
        
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
        
        if (prediction!.letterProbability["\(prediction!.letter)"]) != nil {
            if prediction!.letterProbability["\(prediction!.letter)"]! > 0.60 {
                //print("är högre: " + "\(prediction!.___letterProbability["\(prediction!.___letter)"])")
                
                let predictedLetter: String = prediction!.letter
                return predictedLetter
                
            } else {
                //print("är lägre: " + "\(prediction!.___letterProbability["\(prediction!.___letter)"])")
                
                return ""
            }
        }
        
        return ""
    }
    
    
}
