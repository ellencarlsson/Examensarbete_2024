//
//  TestModel.swift
//  Examensarbete_2024 Watch App
//
//  Created by Ellen Carlsson on 2024-03-26.
//

import Foundation
import CoreML

class MotionDetectionModel {
    
    func stillMotionDetecter (incommingMotionData: StillMotionData) -> aljonasdetectionOutput? {
        
        do {
            
            let config = MLModelConfiguration()
            
            let model = try aljonasdetection(configuration: config)
            
            let prediction = try model.prediction(
                attitude_pitch: incommingMotionData.attitude_pitch,
                attitude_roll: incommingMotionData.attitude_roll,
                attitude_yaw: incommingMotionData.attitude_yaw,
                gravity_x: incommingMotionData.gravity_x,
                gravity_y: incommingMotionData.gravity_y,
                gravity_z: incommingMotionData.gravity_z)
            
            return prediction
            
        } catch {
            
        }
        
        return nil
        
    }
    

    func movingMotionDetector(movingMotionData: [MovingMotionData]) -> aljonasworddetector2Output? {
        do {
            let config = MLModelConfiguration()
            let model = try aljonasworddetector2(configuration: config)
            let inputSize: NSNumber = 4
            
            
            
                        
            let attitudePitchMultiArray = try MLMultiArray(shape: [inputSize], dataType: .double)
            let attitudeRollMultiArray = try MLMultiArray(shape: [inputSize], dataType: .double)
            let attitudeYawMultiArray = try MLMultiArray(shape: [inputSize], dataType: .double)
            let gravityXMultiArray = try MLMultiArray(shape: [inputSize], dataType: .double)
            let gravityYMultiArray = try MLMultiArray(shape: [inputSize], dataType: .double)
            let gravityZMultiArray = try MLMultiArray(shape: [inputSize], dataType: .double)
            let rotationRateXMultiArray = try MLMultiArray(shape: [inputSize], dataType: .double)
            let rotationRateYMultiArray = try MLMultiArray(shape: [inputSize], dataType: .double)
            let rotationRateZMultiArray = try MLMultiArray(shape: [inputSize], dataType: .double)
            let timeStampMultiArray = try MLMultiArray(shape: [inputSize], dataType: .double)
            let stateInMultiArray = try MLMultiArray(shape: [400], dataType: .double)
            
            for (index, data) in movingMotionData.prefix(4).enumerated() {
                attitudePitchMultiArray[index] = NSNumber(value: data.attitude_pitch)
                attitudeRollMultiArray[index] = NSNumber(value: data.attitude_roll)
                attitudeYawMultiArray[index] = NSNumber(value: data.attitude_yaw)
                gravityXMultiArray[index] = NSNumber(value: data.gravity_x)
                gravityYMultiArray[index] = NSNumber(value: data.gravity_y)
                gravityZMultiArray[index] = NSNumber(value: data.gravity_z)
                rotationRateXMultiArray[index] = NSNumber(value: data.rotationRate_x)
                rotationRateYMultiArray[index] = NSNumber(value: data.rotationRate_y)
                rotationRateZMultiArray[index] = NSNumber(value: data.rotationRate_z)
                timeStampMultiArray[index] = NSNumber(value: data.timeStamp)
                
            }
            
            fill(mlMultiArray: stateInMultiArray, with: 1.0)
            
            // Fyll MLMultiArrays med hårdkodade värdena
            
            
            // Gör förutsägelsen med MLMultiArrays
            let prediction = try model.prediction(
                attitude_pitch: attitudePitchMultiArray,
                attitude_roll: attitudeRollMultiArray,
                attitude_yaw: attitudeYawMultiArray,
                gravity_x: gravityXMultiArray,
                gravity_y: gravityYMultiArray,
                gravity_z: gravityZMultiArray,
                rotationRate_x: rotationRateXMultiArray,
                rotationRate_y: rotationRateYMultiArray,
                rotationRate_z: rotationRateZMultiArray,
                timeStamp: timeStampMultiArray,
                stateIn: stateInMultiArray
            )
            
            print(prediction.labelProbability, prediction.labelProbability)
            return prediction
            
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    // fyller MLMultiArray med testvärden
    private func fill(mlMultiArray: MLMultiArray, with value: Double) {
        for i in 0..<mlMultiArray.count {
            mlMultiArray[i] = NSNumber(value: value)
        }
    }
}


