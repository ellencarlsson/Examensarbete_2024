

import Foundation
import CoreMotion
import Combine


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
    @Published var movingMotionArray: [MovingMotionData] = []
    var newTime = 0.0
    let timeInterval = 0.1

    // Initializes the motion updates, resets the time and array.
    func startMotionUpdates() {
        resetTimeAndArray()  // Reset time and array at start
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = timeInterval
            motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { [weak self] (data, error) in
                guard let self = self, let deviceMotionData = data else { return }

                if self.newTime > 1.2 {
                    self.stopMotionUpdates()
                    return
                }

                let newData = MovingMotionData(
                    timeStamp: self.newTime,
                    attitude_pitch: deviceMotionData.attitude.pitch,
                    attitude_roll: deviceMotionData.attitude.roll,
                    attitude_yaw: deviceMotionData.attitude.yaw,
                    gravity_x: deviceMotionData.gravity.x,
                    gravity_y: deviceMotionData.gravity.y,
                    gravity_z: deviceMotionData.gravity.z,
                    rotationRate_x: deviceMotionData.rotationRate.x,
                    rotationRate_y: deviceMotionData.rotationRate.y,
                    rotationRate_z: deviceMotionData.rotationRate.z
                )
                self.movingMotionArray.append(newData)
                self.newTime += self.timeInterval
            }
        }
    }

    // Stops the motion updates and prints a message.
    func stopMotionUpdates() {
        motionManager.stopDeviceMotionUpdates()
        print("Motion updates stopped.")
    }

    // Resets the time and the array holding the motion data.
    func resetTimeAndArray() {
        newTime = 0.0
        movingMotionArray = []
    }

    // Returns the collected moving motion data.
    func getMovingMotionData() -> [MovingMotionData] {
        return movingMotionArray
    }
}




