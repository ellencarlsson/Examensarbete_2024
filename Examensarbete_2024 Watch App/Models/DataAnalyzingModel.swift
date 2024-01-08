//
//  DataAnalyzingModel.swift
//  Examensarbete_2024 Watch App
//
//  Created by Ellen Carlsson on 2024-01-08.
//

import Foundation

class DataAnalyzingModel {
    let dataManager = DataManager()
    
    func compareResults(){
        dataManager.readDataFromDatabase { motionData in
            if let motionData = motionData {
                print(motionData)
            } else {
                print("Failed to read data")
            }
        }

        
    }
}
