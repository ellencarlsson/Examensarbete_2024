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
    let rotationRate_x: Double
    let rotationRate_y: Double
    let rotationRate_z: Double
    let gravity_x: Double
    let gravity_y: Double
    let gravity_z: Double
    let sensorLocation_hashValue: Int
    let heading: Double


    init(attitude_pitch: Double = 0.0, attitude_roll: Double = 0.0, attitude_yaw: Double = 0.0, rotationRate_x: Double = 0.0, rotationRate_y: Double = 0.0, rotationRate_z: Double = 0.0, gravity_x: Double = 0.0, gravity_y: Double = 0.0, gravity_z: Double = 0.0, sensorLocation_hashValue: Int = 0, heading: Double = 0) {
        self.attitude_pitch = attitude_pitch
        self.attitude_roll = attitude_roll
        self.attitude_yaw = attitude_yaw
        self.rotationRate_x = rotationRate_x
        self.rotationRate_y = rotationRate_y
        self.rotationRate_z = rotationRate_z
        self.gravity_x = gravity_x
        self.gravity_y = gravity_y
        self.gravity_z = gravity_z
        self.sensorLocation_hashValue = sensorLocation_hashValue
        self.heading = heading
    }
}

//Device motion. Set the deviceMotionUpdateInterval property to specify an update interval. Call the startDeviceMotionUpdates(using:)or startDeviceMotionUpdates(using:to:withHandler:) or startDeviceMotionUpdates(to:withHandler:) method, passing in a block of type CMDeviceMotionHandler. With the former method, you can specify a reference frame to be used for the attitude estimates. Rotation-rate data is passed into the block as CMDeviceMotion objects.

//Gyroscope. Set the gyroUpdateInterval property to specify an update interval. Call the startGyroUpdates(to:withHandler:) method, passing in a block of type CMGyroHandler. Rotation-rate data is passed into the block as CMGyroData objects.

class MotionModel {
    private let motionManager = CMMotionManager()
    private let databaseViewModel = DatabaseViewModel()
    let dataAnalyzingModel = DataAnalyzingModel()
    var motionData = MotionData()
    let timeInterval = 0.1
    
    

    func startGyroscopeUpdates(){ //funkar inte helvete
        print("1")
        if motionManager.isGyroAvailable {
            print("2")
            motionManager.gyroUpdateInterval = timeInterval
            print("3")
            motionManager.startGyroUpdates(to: OperationQueue.main) { data, error in
                print("4")
                if let gyroMotionData = data {
                    print("5")
                    let rotationRate = gyroMotionData.rotationRate
                    print("6")
                    print("rotationrate x, y, z: \(rotationRate.x), \(rotationRate.y), \(rotationRate.z)")
                    
                    
                }
            }
        }
    }
    
    func stopGyroscopeUpdates(){
        motionManager.stopGyroUpdates()
    }
    
    func startMotionUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = timeInterval
            motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { (data, error) in
                if let deviceMotionData = data {
                    let attitude = deviceMotionData.attitude
                    let rotationRate = deviceMotionData.rotationRate
                    let magneticField = deviceMotionData.magneticField
                    let gravity = deviceMotionData.gravity
                    let sensorLocation_hashValue = deviceMotionData.sensorLocation.hashValue
                    let heading = deviceMotionData.heading
                    //let userAcceeleration = deviceMotionData.userAcceleration
                    //let heading = deviceMotionData.heading

                    self.motionData = MotionData(attitude_pitch: attitude.pitch, attitude_roll: attitude.roll, attitude_yaw: attitude.yaw, rotationRate_x: rotationRate.x, rotationRate_y: rotationRate.y, rotationRate_z: rotationRate.z, gravity_x: gravity.x, gravity_y: gravity.y, gravity_z: gravity.z, sensorLocation_hashValue: sensorLocation_hashValue, heading: heading)
                    
                    //print(rotationRate.x, rotationRate.y, rotationRate.z)
                }
            }
        }
    }

    func stopMotionUpdates() {
        motionManager.stopDeviceMotionUpdates()
        databaseViewModel.addDataToDatabase(motionData: motionData)
        dataAnalyzingModel.compareResults()
    }
        
}
