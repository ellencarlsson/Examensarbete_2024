//
//  DataManager.swift
//  Examensarbete_2024 Watch App
//
//  Created by Ellen Carlsson on 2024-01-05.
//

import Foundation
import FirebaseDatabase


class DataManager: ObservableObject {
    private let databaseURL = "https://examensarbete2024-6a1dc-default-rtdb.europe-west1.firebasedatabase.app"
    private let path = "/a/.json" //ändra här för att ändra namn på table
    
    private var messageHandle: URLSessionDataTask?
    
    func stopMessageListener() {
        messageHandle?.cancel()
    }
    
    func addDataToDatabase(motionData: MotionData) {
        let encoder = JSONEncoder()
        encoder.nonConformingFloatEncodingStrategy = .convertToString(positiveInfinity: "Infinity", negativeInfinity: "-Infinity", nan: "NaN")
        
        guard let jsonData = try? encoder.encode(motionData) else {
            print("Error encoding gestureData")
            return
        }
        
        let url = URL(string: databaseURL + path)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error adding data to database: \(error)")
            } else {
                print("Data added to database")
            }
        }
        
        task.resume()
        
    }
}
