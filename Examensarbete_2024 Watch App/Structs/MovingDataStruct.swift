//
//  MovingDataStruct.swift
//  Examensarbete_2024 Watch App
//
//  Created by Ellen Carlsson on 2024-04-01.
//

import Foundation

struct MovingData: Encodable, Decodable {
    let letter: String
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
        letter: String = currentLetter,
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
