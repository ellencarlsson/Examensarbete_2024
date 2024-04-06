import Foundation
import CoreML

class GestureViewModel: ObservableObject {
    private let stillMotionModel = StillMotionModel()
    private let movingMotionModel = MovingMotionModel()
    private let testModel = MotionDetectionModel()
    private let databaseViewModel = DatabaseViewModel()

    // Start the still motion updates.
    func startStillMotionModel(){
        stillMotionModel.startMotionUpdates()
    }
    
    func startStillMotionModelWithCompletion (completion: @escaping () -> Void) {
            stillMotionModel.startMotionUpdatesWithCompletion {
                let data = self.getCurrentStillMotion()
                completion()
            }
    }
    
    // Start the moving motion updates.
    func startMovingMotionModel() {
        movingMotionModel.startMotionUpdates()
    }
    
    func startMovingMotionModelWithCompletion (completion: @escaping () -> Void) {
        //print("börjar detecta")
        var counter = 0
            movingMotionModel.startMotionUpdatesWithCompletion {
                counter += 1
                if counter == 12 {
                    //print("slutar detecta")
                    completion()
                }

            }
    }
    
    // Stop still motion updates.
    func stopStillMotionModel() {
        stillMotionModel.stopMotionUpdates()
    }
    
    // Stop moving motion updates.
    func stopMovingMotionModel() {
        movingMotionModel.stopMotionUpdates()
    }
    
    // Get the current still motion data.
    func getCurrentStillMotion() -> StillMotionData {
        return stillMotionModel.motionData
    }
    
    // Add the still gesture to the database.
    func addStillGestureToDatabase() {
        stillMotionModel.stopMotionUpdates()
        let stillMotionData = getCurrentStillMotion()
        databaseViewModel.addStillDataToDatabase(stillMotionData: stillMotionData)
    }
    
    // Add the moving gesture data to the database.
    func addMovingDataToDatabase() {
        movingMotionModel.stopMotionUpdates()
        let movingMotionData = movingMotionModel.getMovingMotionData()
        databaseViewModel.addMovingDataToDatabase(movingMotionData: movingMotionData)
        movingMotionModel.resetTimeAndArray()
    }
    
    // Get the predicted word from the moving motion data.
    func getPredictedWord() -> String {
        let movingData = movingMotionModel.getMovingMotionData()
        guard !movingData.isEmpty else {
            print("No motion data available for prediction.")
            return ""
        }

        if let prediction = testModel.movingMotionDetector(movingMotionData: movingData) {
                return prediction.label
            } else {
                return ""
            }
    }
    
    func getPredictedLetter() -> String {
        let stillData = stillMotionModel.getCurrentMotion()
 
        if let prediction = testModel.stillMotionDetecter(incommingMotionData: stillData) {
            print(prediction.letterProbability)
                return prediction.letter
            } else {
                return ""
            }
    }
}
