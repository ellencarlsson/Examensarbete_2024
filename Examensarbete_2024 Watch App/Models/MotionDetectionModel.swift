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
    

    func movingMotionDetector() -> ellenWordOutput? {
        do {
            let config = MLModelConfiguration()
            let model = try ellenWord(configuration: config)
            let inputSize: NSNumber = 4
            
            
            let tempMotionData: [MovingMotionData] = [
                MovingMotionData(
                    word: "rumpa",
                    timeStamp: 0.0,
                    attitude_pitch: -0.2443,
                    attitude_roll: -0.2443,
                    attitude_yaw: -0.2443,
                    gravity_x: -0.2443,
                    gravity_y: -0.2443,
                    gravity_z: -0.2443,
                    rotationRate_x: -0.2443,
                    rotationRate_y: -0.2443,
                    rotationRate_z: -0.2443),
                
                MovingMotionData(
                    word: "rumpa",
                    timeStamp: 0.2,
                    attitude_pitch: -0.333,
                    attitude_roll: -0.333,
                    attitude_yaw: -0.333,
                    gravity_x: -0.333,
                    gravity_y: -0.333,
                    gravity_z: -0.333,
                    rotationRate_x: -0.333,
                    rotationRate_y: -0.333,
                    rotationRate_z: -0.333),
                
                MovingMotionData(
                    word: "rumpa",
                    timeStamp: 0.2,
                    attitude_pitch: -0.888,
                    attitude_roll: -0.888,
                    attitude_yaw: -0.888,
                    gravity_x: -0.888,
                    gravity_y: -0.888,
                    gravity_z: -0.888,
                    rotationRate_x: -0.888,
                    rotationRate_y: -0.888,
                    rotationRate_z: -0.888),
                
                MovingMotionData(
                    word: "rumpa",
                    timeStamp: 0.4,
                    attitude_pitch: -0.999,
                    attitude_roll: -0.999,
                    attitude_yaw: -0.999,
                    gravity_x: -0.999,
                    gravity_y: -0.999,
                    gravity_z: -0.999,
                    rotationRate_x: -0.999,
                    rotationRate_y: -0.999,
                    rotationRate_z: -0.999)
            ]
                        
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
            
            for (index, data) in tempMotionData.enumerated() {
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
            
            print(attitudeYawMultiArray)
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


