//
//  MotionModel.swift
//  Examensarbete_2024 Watch App
//
//  Created by Ellen Carlsson on 2024-01-05.
//

import Foundation
import CoreMotion

private let currentLetter = "d" // This variable represents the charachter that will be trained

struct StillMotionData: Encodable, Decodable {
    let letter: String
    let attitude_pitch: Double
    let attitude_roll: Double
    let attitude_yaw: Double
    let gravity_x: Double
    let gravity_y: Double
    let gravity_z: Double

    init(
        letter: String = currentLetter,
        attitude_pitch: Double = 0.0,
        attitude_roll: Double = 0.0,
        attitude_yaw: Double = 0.0,
        gravity_x: Double = 0.0,
        gravity_y: Double = 0.0,
        gravity_z: Double = 0.0
        
    ) {
        self.letter = letter
        self.attitude_pitch = attitude_pitch
        self.attitude_roll = attitude_roll
        self.attitude_yaw = attitude_yaw
        self.gravity_x = gravity_x
        self.gravity_y = gravity_y
        self.gravity_z = gravity_z
        
    }
}

class StillMotionModel: ObservableObject {
    private let motionManager = CMMotionManager()
    @Published var motionData = StillMotionData()
    let timeInterval = 0.01
    
    func startMotionUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = timeInterval
            motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { (data, error) in
                if let deviceMotionData = data {
                    
                    let attitude = deviceMotionData.attitude
                    let gravity = deviceMotionData.gravity
                    
                    // attitude represent the orientation of the device in three-dimensional space. They indicate how much the device is tilted along its respective axes.
                    
                    // gravity provides information about the direction of gravity relative to the device's coordinate system.

                    self.motionData = StillMotionData(
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
    
    func startMotionUpdatesWithCompletion(completion: @escaping () -> Void) {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = timeInterval
            motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { (data, error) in
                if let deviceMotionData = data {
                    
                    let attitude = deviceMotionData.attitude
                    let gravity = deviceMotionData.gravity
                    
                    // attitude represent the orientation of the device in three-dimensional space. They indicate how much the device is tilted along its respective axes.
                    
                    // gravity provides information about the direction of gravity relative to the device's coordinate system.

                    self.motionData = StillMotionData(
                        attitude_pitch: attitude.pitch,
                        attitude_roll: attitude.roll,
                        attitude_yaw: attitude.yaw,
                        gravity_x: gravity.x,
                        gravity_y: gravity.y,
                        gravity_z: gravity.z
                       
                        
                    )
                    
                    completion()
                    //print(self.motionData)
                }
            }
        }
    }
    
    func stopMotionUpdates () {
        motionManager.stopDeviceMotionUpdates()
        //print("stopping at: " + "\(self.motionData)")
    }
        
    func getCurrentMotion() -> StillMotionData {
        //print("current data: " + "\(self.motionData)")
        return self.motionData
    }
}
