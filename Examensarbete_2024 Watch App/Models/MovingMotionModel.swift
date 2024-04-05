//
//  MovingMotionModel.swift
//  Examensarbete_2024 Watch App
//
//  Created by Ellen Carlsson on 2024-04-01.
//

import Foundation
import CoreMotion

private let word: String = "imorgon"

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

        word: String = "imorgon", // ändra här

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
        self.letter = letter
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
    let timeInterval = 0.1
    var newTime = 0.0
    
    private var movingMotionArray: [MovingMotionData] = []
    
    func startMotionUpdates() {
            if motionManager.isDeviceMotionAvailable {
                motionManager.deviceMotionUpdateInterval = timeInterval
                motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { (data, error) in
                    guard let deviceMotionData = data else { return }
                    
                    // Round 'newTime' to 1 decimal place
                    self.newTime = round(self.newTime * 10) / 10
                    
                    // Stop updates if 'newTime' is greater than or equal to 1.2
                    if self.newTime > 1.2 {
                        self.motionManager.stopDeviceMotionUpdates()
                        print(self.movingMotionArray)
                        return
                    }
                    
                    let attitude = deviceMotionData.attitude
                    let gravity = deviceMotionData.gravity
                    let rotationRate = deviceMotionData.rotationRate
                    
                    self.movingMotionData = MovingMotionData(
                        word: word,
                        timeStamp: self.newTime,
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
                    

                    // Increment 'newTime' by 'timeInterval'
                    self.newTime += self.timeInterval
kaos
                    
                     

                }
                
                
            }
        }



    }

    
    func stopMotionUpdates () {
        motionManager.stopDeviceMotionUpdates()
    }
    
    func getMovingMotionData() -> [MovingMotionData] {
        //print("current array: " + "\(self.movingMotionArray)")
        return self.movingMotionArray
    }
}
