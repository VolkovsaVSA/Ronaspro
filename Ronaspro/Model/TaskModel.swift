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
    var answers: [String: String]
    var totalCost: Double
    
    var dictionary: [String: Any] {
        return ["id": id, "title": title, "description": description, "ownerID": ownerID, "dateAdded": dateAdded, "responsibles": responsibles, "answers": answers, "totalCost": totalCost]
    }
    
    init(id: String, title: String, description: String, ownerID: String, dateAdded: Date, responsibles: [String], answers: [String: String], totalCost: Double) {
        self.id = id
        self.title = title
        self.description = description
        self.ownerID = ownerID
        self.dateAdded = dateAdded
        self.responsibles = responsibles
        self.answers = answers
        self.totalCost = totalCost
    }
    
    init?(dictionary: [String: Any]) {
        var id: String
        var title: String
        var description: String
        var ownerID: String
        var dateAdded: Date
        var responsibles: [String]
        var answers: [String: String]
        var totalCost: Double
       
        if let idInit = dictionary["id"] as? String {id = idInit} else {id = ""}
        if let titleInit = dictionary["title"] as? String {title = titleInit} else {title = ""}
        if let descriptionInit = dictionary["description"] as? String {description = descriptionInit} else {description = ""}
        if let ownerIDInit = dictionary["ownerID"] as? String {ownerID = ownerIDInit} else {ownerID = ""}
        if let dateAddedInit = dictionary["dateAdded"] as? Date {dateAdded = dateAddedInit} else {dateAdded = Date()}
        if let responsiblesInit = dictionary["responsibles"] as? [String] {responsibles = responsiblesInit} else {responsibles = [String]()}
        if let answersInit = dictionary["answers"] as? [String: String] {answers = answersInit} else {answers = [String: String]()}
        if let totalCostInit = dictionary["totalCost"] as? Double {totalCost = totalCostInit} else {totalCost = 0}
        
        self.init(id: id, title: title, description: description, ownerID: ownerID, dateAdded: dateAdded, responsibles: responsibles, answers: answers, totalCost: totalCost)

    }
    
    
}
