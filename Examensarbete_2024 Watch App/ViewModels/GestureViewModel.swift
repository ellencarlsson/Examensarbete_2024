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
    

      

    // Start the moving motion updates.
    func startMovingMotionModel() {
        movingMotionModel.startMotionUpdates()
    }
    
    // Stop still motion updates.
    private func stopStillMotionModel() {
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
                print("Detektion av ordet lyckades: \(prediction.label)")
                return prediction.label
            } else {
                print("Ingen förutsägelse gjord.")
                return ""
            }
    }
    
    // The `getPredictedLetter` method seems redundant in the context as it's very similar to `getPredictedWord`.
    // If it serves a different purpose, provide its definition here.
    // Otherwise, consider removing it to avoid confusion and redundancy.
}
