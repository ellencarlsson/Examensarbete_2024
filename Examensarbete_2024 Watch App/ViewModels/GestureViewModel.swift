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
    
    func startMovingMotionModel ()  {
        movingMotionModel.startMotionUpdates {
            // This closure will be executed once startMotionUpdates completes its task.
            // Any code here will be executed after the motion updates are finished.
            
            // For example, if you have some function to call after the updates are done, call it here.
            // If you need to update the UI or perform other actions, do that inside this closure.
            
        }
    }
    
    func getCurrentMovingData () -> [MovingMotionData]{
        return movingMotionModel.getMovingMotionData()
    }
    
    
    
    
    
    
    func addMovingDataToDatabase () {
        movingMotionModel.stopMotionUpdates()
        let movingMotionData = movingMotionModel.getMovingMotionData()
        databaseViewModel.addMovingDataToDatabase(movingMotionData: movingMotionData)
        movingMotionModel.resetTimeAndArray()
    }
    
    func getPredictedWord(completion: @escaping (String) -> Void) {
        self.movingMotionModel.startMotionUpdates {
            let movingMotionData = self.movingMotionModel.getMovingMotionData()
            print(movingMotionData)
            guard let prediction = self.testModel.movingMotionDetector(movingMotionData: movingMotionData) else {
                completion("")
                return
            }

            self.movingMotionModel.stopMotionUpdates()

            if let probability = prediction.labelProbability[prediction.label], probability > 0.60 {
                completion(prediction.label)
            } else {
                completion("")
            }
        }
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
