//
//  DataManager.swift
//  Examensarbete_2024 Watch App
//
//  Created by Ellen Carlsson on 2024-01-05.
//

import Foundation
import FirebaseDatabase


class DataManager: ObservableObject {
    @Published var message = "Does it work?"

    private let databaseURL = "https://examensarbete2024-6a1dc-default-rtdb.europe-west1.firebasedatabase.app" // Replace with your Firebase project's URL
    private let messagesPath = "/.json" // Replace with your specific path

    private var messageHandle: URLSessionDataTask?

    func startMessageListener() {
        let url = URL(string: databaseURL + messagesPath)!

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let value = json.values.first as? String {
                    DispatchQueue.main.async {
                        self.message = value
                    }
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }

        task.resume()
        messageHandle = task
    }

    func stopMessageListener() {
        messageHandle?.cancel()
    }

    func addMessageToDatabase(newMessage: String) {
        let url = URL(string: databaseURL + messagesPath)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["message": newMessage])

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle the response if needed
        }

        task.resume()
    }
}
