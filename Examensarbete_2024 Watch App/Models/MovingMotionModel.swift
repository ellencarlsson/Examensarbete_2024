//
//  MovingMotionModel.swift
//  Examensarbete_2024 Watch App
//
//  Created by Ellen Carlsson on 2024-04-01.
//

import Foundation
import CoreMotion

private let word: String = "forsta"

struct MovingMotionData: Encodable, Decodable {
    let word: String
    var timeStamp: Double
    let attitude_pitch: Double
    let attitude_roll: Double
    let attitude_yaw: Double
    let gravity_x: Double
    let gravity_y: Double
    let gravity_z: Double
    let rotationRate_x: Double
    let rotationRate_y: Double
    let rotationRate_z: Double
    
    init(
        word: String = "forsta", // ändra här
        timeStamp: Double = 0.0,
        attitude_pitch: Double = 0.0,
        attitude_roll: Double = 0.0,
        attitude_yaw: Double = 0.0,
        gravity_x: Double = 0.0,
        gravity_y: Double = 0.0,
        gravity_z: Double = 0.0,
        rotationRate_x: Double = 0.0,
        rotationRate_y: Double = 0.0,
        rotationRate_z: Double = 0.0
    ) {
        self.word = word
        self.timeStamp = timeStamp
        self.attitude_pitch = attitude_pitch
        self.attitude_roll = attitude_roll
        self.attitude_yaw = attitude_yaw
        self.gravity_x = gravity_x
        self.gravity_y = gravity_y
        self.gravity_z = gravity_z
        self.rotationRate_x = rotationRate_x
        self.rotationRate_y = rotationRate_y
        self.rotationRate_z = rotationRate_z
    }
}

class MovingMotionModel: ObservableObject {
    private let motionManager = CMMotionManager()
    var movingMotionData = MovingMotionData()
    let timeInterval = 0.2
    var newTime = 0.0
    
    private var movingMotionArray: [MovingMotionData] = []
    
    func startMotionUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = timeInterval
            motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { (data, error) in
                if let deviceMotionData = data {
                    let attitude = deviceMotionData.attitude
                    let gravity = deviceMotionData.gravity
                    let rotationRate = deviceMotionData.rotationRate
                    
                    // Update 'newTime' to the next expected timestamp
                    self.newTime = Double(self.movingMotionArray.count) * 0.2
                    
                    self.movingMotionData = MovingMotionData(
                        word: word, // Assuming 'word' is the variable you want to use
                        timeStamp: self.newTime, // Set the timeStamp for this entry
                        attitude_pitch: attitude.pitch,
                        attitude_roll: attitude.roll,
                        attitude_yaw: attitude.yaw,
                        gravity_x: gravity.x,
                        gravity_y: gravity.y,
                        gravity_z: gravity.z,
                        rotationRate_x: rotationRate.x,
                        rotationRate_y: rotationRate.y,
                        rotationRate_z: rotationRate.z
                    )
                    
                    self.movingMotionArray.append(self.movingMotionData)
                    
                    // Check if we've reached the last required timestamp
                    if self.newTime >= 0.6 {
                        self.motionManager.stopDeviceMotionUpdates()
                        // No need to map and update 'timeStamp', it's already set correctly
                        print(self.movingMotionArray)
                        // Break out of the update loop
                        return
                    }
                }
            }
        }
    }


    
    func stopMotionUpdates () {
        motionManager.stopDeviceMotionUpdates()
    }
    
    func resetTimeAndArray () {
        self.newTime = 0
        self.movingMotionArray = []
    }
    
    func getMovingMotionData() -> [MovingMotionData] {
        //print("current array: " + "\(self.movingMotionArray)")
        return self.movingMotionArray
    }
}
