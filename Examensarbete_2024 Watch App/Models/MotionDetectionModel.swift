//
//  TestModel.swift
//  Examensarbete_2024 Watch App
//
//  Created by Ellen Carlsson on 2024-03-26.
//

import Foundation
import CoreML

class MotionDetectionModel {
    
    func stillMotionDetecter (incommingMotionData: StillMotionData) -> DetectionAERandomForestOutput? {
        
        do {
            
            let config = MLModelConfiguration()
            
            let model = try DetectionAERandomForest(configuration: config)
            
            let prediction = try model.prediction(
                ___attitude_pitch: incommingMotionData.attitude_pitch,
                ___attitude_roll: incommingMotionData.attitude_roll,
                ___attitude_yaw: incommingMotionData.attitude_yaw,
                ___gravity_x: incommingMotionData.gravity_x,
                ___gravity_y: incommingMotionData.gravity_y,
                ___gravity_z: incommingMotionData.gravity_z)

            return prediction
            
        } catch {
            
        }
        
        return nil
        
    }
    
    func movingMotionDetecter () -> MovingMotionDetectionOutput? {
        do {
            
        } catch {
            
        }
        
        return nil
    }
}
