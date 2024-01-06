//
//  MotionModel.swift
//  Examensarbete_2024 Watch App
//
//  Created by Ellen Carlsson on 2024-01-05.
//

import Foundation
import CoreMotion

class MotionModel {
    private let motionManager = CMMotionManager()

    func startMotionUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1 // Update interval in seconds
            motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { (data, error) in
                if let deviceMotionData = data {
                    // Access device motion data (accelerometer, gyro, magnetometer)
                    let attitude = deviceMotionData.attitude
                    let rotationRate = deviceMotionData.rotationRate
                    let magneticField = deviceMotionData.magneticField
                    let userAcceeleration = deviceMotionData.userAcceleration

                    // Do something with the data
                    //print("Attitude: \(attitude), Rotation Rate: \(rotationRate), Magnetic Field: \(magneticField)")
                    print("attitude.pitch: \(attitude.pitch)")
                    
                    
                }
            }
        }
    }

    func stopMotionUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }
}
