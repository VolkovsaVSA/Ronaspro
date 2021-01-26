//
//  TaskAnswerModel.swift
//  Ronaspro
//
//  Created by Sergey Volkov on 26.01.2021.
//

import Foundation

struct TaskAnswerModel {
    var id: String
    var parentTask: String
    var responsibleID: String
    var totalCost: Double
    var workNames: [String]
    var workCosts: [Double]
    
    var dictionary: [String: Any] {
        return ["id": id, "parentTask": parentTask, "responsibleID": responsibleID, "totalCost": totalCost, "workNames": workNames, "workCosts": workCosts]
    }
}
