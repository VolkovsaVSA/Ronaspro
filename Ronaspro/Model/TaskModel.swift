//
//  TaskModel.swift
//  Ronaspro
//
//  Created by Sergey Volkov on 25.01.2021.
//

import Foundation


struct TaskModel {
    var id: String
    var title: String
    var description: String
    var ownerID: String
    var dateAdded: Date
    var responsibles: [String]
    
    var dictionary: [String: Any] {
        return ["id": id, "title": title, "description": description, "ownerID": ownerID, "dateAdded": dateAdded, "responsibles": responsibles]
    }
    
    
}
