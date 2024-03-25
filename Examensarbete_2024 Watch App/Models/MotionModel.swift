//
//  MotionModel.swift
//  Examensarbete_2024 Watch App
//
//  Created by Ellen Carlsson on 2024-01-05.
//

import Foundation
import CoreMotion

struct MotionData: Encodable, Decodable {
    let attitude_pitch: Double
    let attitude_roll: Double
    let attitude_yaw: Double
    let gravity_x: Double
    let gravity_y: Double
    let gravity_z: Double

    init(
        attitude_pitch: Double = 0.0,
         attitude_roll: Double = 0.0,
         attitude_yaw: Double = 0.0,
         gravity_x: Double = 0.0,
         gravity_y: Double = 0.0,
         gravity_z: Double = 0.0
    ) {
        self.attitude_pitch = attitude_pitch
        self.attitude_roll = attitude_roll
        self.attitude_yaw = attitude_yaw
        self.gravity_x = gravity_x
        self.gravity_y = gravity_y
        self.gravity_z = gravity_z
    }
}

class MotionModel {
    private let motionManager = CMMotionManager()
    private let databaseViewModel = DatabaseViewModel()
    var motionData = MotionData()
    let timeInterval = 0.1
    
    func startMotionUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = timeInterval
            motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { (data, error) in
                if let deviceMotionData = data {
                    let attitude = deviceMotionData.attitude
                    let gravity = deviceMotionData.gravity
                    
                    // attitude represent the orientation of the device in three-dimensional space. They indicate how much the device is tilted along its respective axes.
                    
                    // gravity provides information about the direction of gravity relative to the device's coordinate system.

                    self.motionData = MotionData(
                        attitude_pitch: attitude.pitch,
                        attitude_roll: attitude.roll,
                        attitude_yaw: attitude.yaw,
                        gravity_x: gravity.x,
                        gravity_y: gravity.y,
                        gravity_z: gravity.z
                    )
                }
            }
        }
    }

    func stopMotionUpdates() {
        motionManager.stopDeviceMotionUpdates()
        databaseViewModel.addDataToDatabase(motionData: motionData)
    }
        
}
