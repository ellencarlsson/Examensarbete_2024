//
//  DataManager.swift
//  Examensarbete_2024 Watch App
//
//  Created by Ellen Carlsson on 2024-01-05.
//

/*import Foundation
import FirebaseDatabase

class DataManager: ObservableObject {
  @Published var message = "Does it work?"
  lazy var messageRef: DatabaseReference = Database.database().reference().ref.child("/message")
  var messageHandle: DatabaseHandle?
  
  func startMessageListener() {
    messageHandle = messageRef.observe(.value, with: { snapshot in
      if let value = snapshot.value as? String{
        self.message = value
      }
    })
  }
  
  func stopMessageListener() {
    if messageHandle != nil {
      messageRef.removeObserver(withHandle: messageHandle!)
    }
  }
}*/
