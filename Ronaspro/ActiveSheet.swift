//
//  ActiveSheet.swift
//  Ronaspro
//
//  Created by Sergey Volkov on 25.01.2021.
//

import Foundation

enum ActiveSheet: Identifiable {
    
    case staffPositionList, showMainView
    var id: Int {
        hashValue
    }
}

