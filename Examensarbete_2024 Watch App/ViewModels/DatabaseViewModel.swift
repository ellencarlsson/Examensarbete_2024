//
//  DatabaseViewModel.swift
//  Examensarbete_2024 Watch App
//
//  Created by Ellen Carlsson on 2024-01-06.
//

import Foundation

class DatabaseViewModel{
    let dataManager = DataManagerModel()
    
    func addStillDataToDatabase(stillMotionData: StillMotionData) {
        dataManager.addStillDataToDatabase(stillMotionData: stillMotionData)
    }
    
    func addMovingDataToDatabase(movingMotionData: [MovingMotionData]) {
        dataManager.addMovingDataToDatabase(movingMotionData: movingMotionData)
    }
}
