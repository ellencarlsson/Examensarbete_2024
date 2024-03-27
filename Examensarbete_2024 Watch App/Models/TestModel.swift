//
//  TestModel.swift
//  Examensarbete_2024 Watch App
//
//  Created by Ellen Carlsson on 2024-03-26.
//

import Foundation
import CoreML

class TestModel {
    
    func testModel (incommingMotionData: MotionData) -> HandSignDetection1Output? {
        
        do {
            
            let config = MLModelConfiguration()
            
            let model = try HandSignDetection1(configuration: config)
            
            let prediction = try model.prediction(
                ___attitude_pitch: incommingMotionData.attitude_pitch,
                ___attitude_roll: incommingMotionData.attitude_roll,
                ___attitude_yaw: incommingMotionData.attitude_yaw,
                ___gravity_x: incommingMotionData.gravity_x,
                ___gravity_y: incommingMotionData.gravity_y,
                ___gravity_z: incommingMotionData.gravity_z)
            
            
            /*let prediction = try model.prediction(
                ___attitude_pitch: -0.8697275262938803,
                ___attitude_roll: -1.4550543006079972,
                ___attitude_yaw: -1.1709797639257051,
                ___gravity_x: -0.6407191157341003,
                ___gravity_y: 0.7641531825065613,
                ___gravity_z: -0.07449106127023697)*/
            
            return prediction
            
        } catch {
            
        }
        
        
        return nil
    }
}
