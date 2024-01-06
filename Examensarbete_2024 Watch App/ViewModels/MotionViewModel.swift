//
//  MotionViewModel.swift
//  Examensarbete_2024 Watch App
//
//  Created by Ellen Carlsson on 2024-01-05.
//

import Foundation

class MotionViewModel {
    let motionModel = MotionModel()
    
    func startMotionModel(){
        motionModel.startMotionUpdates()
    }
    
    func stopMotionModel(){
        motionModel.stopMotionUpdates()
    }
}
