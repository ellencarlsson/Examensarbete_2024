//
//  MovingMotionModel.swift
//  Examensarbete_2024 Watch App
//
//  Created by Ellen Carlsson on 2024-04-01.
//

import Foundation
import CoreMotion

private let currentWord = "e" // This variable represents the word that will be trained

struct MovingMotionData: Encodable, Decodable {
    let letter: String
    let timeStamp: Double
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
        letter: String = currentWord,
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
    private let databaseViewModel = DatabaseViewModel()
    var movingMotionData = MovingMotionData()
    let timeInterval = 0.2
    
    private var movingMotionArray: [MovingMotionData] = []
    
    func startMotionUpdates() {
        print("inne0")
        if motionManager.isDeviceMotionAvailable {
            print("inne1")
            motionManager.deviceMotionUpdateInterval = timeInterval
            print("inne2")
            motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { (data, error) in
                print("inne3")
                if let deviceMotionData = data {
                    let attitude = deviceMotionData.attitude
                    let gravity = deviceMotionData.gravity
                    let heading = deviceMotionData.heading
                    let rotationRate = deviceMotionData.rotationRate
                    
                    // attitude represent the orientation of the device in three-dimensional space. They indicate how much the device is tilted along its respective axes.
                    
                    // gravity provides information about the direction of gravity relative to the device's coordinate system.

                    self.movingMotionData = MovingMotionData(
                        timeStamp: self.movingMotionData.self.timeStamp + 0.2,
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
                    print("hej")
                    print(self.movingMotionData)
                }
                
                if let error = error {
                    print("error här \(error)")
                }
            }
        }
    }
    
    func stopMotionUpdates () {
        motionManager.stopDeviceMotionUpdates()
    }
        
    func getMovingMotionData() -> [MovingMotionData] {
        print("current data: " + "\(self.movingMotionArray)")
        return self.movingMotionArray
    }
}
