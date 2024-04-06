import Foundation
import CoreML

class MotionDetectionModel {
    
    func stillMotionDetecter(incommingMotionData: StillMotionData) -> aljonasdetectionOutput? {
        do {
            let config = MLModelConfiguration()
            let model = try aljonasdetection(configuration: config)
            let prediction = try model.prediction(
                attitude_pitch: incommingMotionData.attitude_pitch,
                attitude_roll: incommingMotionData.attitude_roll,
                attitude_yaw: incommingMotionData.attitude_yaw,
                gravity_x: incommingMotionData.gravity_x,
                gravity_y: incommingMotionData.gravity_y,
                gravity_z: incommingMotionData.gravity_z
            )
            return prediction
        } catch {
            // It's a good idea to handle the error more specifically here
            print("Error in stillMotionDetecter:", error.localizedDescription)
        }
        return nil
    }
    
    func movingMotionDetector(movingMotionData: [MovingMotionData]) -> testmodelaljona1Output? {
        do {
            let config = MLModelConfiguration()
            let model = try testmodelaljona1(configuration: config)
            let inputSize: Int = 12 // Ensure this is correct for your model

            // Check to ensure we do not exceed the expected input size of the model
            /*guard movingMotionData.count <= inputSize else {
                print("Error: More motion data than expected by model.")
                return nil
            }*/
            
            // Prepare MLMultiArrays to receive the motion data
            let attitudePitchMultiArray = try MLMultiArray(shape: [inputSize as NSNumber], dataType: .double)
            let attitudeRollMultiArray = try MLMultiArray(shape: [inputSize as NSNumber], dataType: .double)
            let attitudeYawMultiArray = try MLMultiArray(shape: [inputSize as NSNumber], dataType: .double)
            let gravityXMultiArray = try MLMultiArray(shape: [inputSize as NSNumber], dataType: .double)
            let gravityYMultiArray = try MLMultiArray(shape: [inputSize as NSNumber], dataType: .double)
            let gravityZMultiArray = try MLMultiArray(shape: [inputSize as NSNumber], dataType: .double)
            let rotationRateXMultiArray = try MLMultiArray(shape: [inputSize as NSNumber], dataType: .double)
            let rotationRateYMultiArray = try MLMultiArray(shape: [inputSize as NSNumber], dataType: .double)
            let rotationRateZMultiArray = try MLMultiArray(shape: [inputSize as NSNumber], dataType: .double)
            let timeStampMultiArray = try MLMultiArray(shape: [inputSize as NSNumber], dataType: .double)
            
            // Populate MLMultiArrays with actual moving motion data
            for (index, data) in movingMotionData.enumerated() {
                guard index < inputSize else {
                    break // Break out of the loop if index exceeds input size
                }

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
            
            // Correctly initialize stateIn
            // Assuming 'stateIn' is a 400 element vector of doubles as previously seen in your code.
            // Adjust the size [400] if your model requires a different state size.
            let stateInMultiArray = try MLMultiArray(shape: [400 as NSNumber], dataType: .double)
            for index in 0..<stateInMultiArray.count {
                stateInMultiArray[index] = 0.0
            }
            
            // Perform the prediction using the populated MLMultiArrays
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
            
            print("Moving motion detection prediction:", prediction.labelProbability)
            return prediction
            
        } catch {
            // Handle errors from model prediction
            print("Error in movingMotionDetector:", error.localizedDescription)
            return nil
        }
    }
}
