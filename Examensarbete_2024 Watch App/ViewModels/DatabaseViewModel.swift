//
//  DatabaseViewModel.swift
//  Examensarbete_2024 Watch App
//
//  Created by Ellen Carlsson on 2024-01-06.
//

import Foundation

class DatabaseViewModel{
    let dataManager = DataManager()
    
    func addData(){
        dataManager.addMessageToDatabase(newMessage: "hej")
    }
}
