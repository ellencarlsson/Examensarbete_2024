//
//  Examensarbete_2024App.swift
//  Examensarbete_2024 Watch App
//
//  Created by Ellen Carlsson on 2024-01-05.
//

import Firebase
import SwiftUI

@main
struct FirebaseExampleApp: App {
  init() {
    FirebaseApp.configure()
  }
  
  var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView()
      }
    }
  }
}





