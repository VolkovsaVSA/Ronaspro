//
//  CurrentUserVM.swift
//  Ronaspro
//
//  Created by Sergey Volkov on 25.01.2021.
//

import Foundation

class CurrentUserVM: ObservableObject {
    static let shared = CurrentUserVM()
    
    @Published var user: MyUserModel?
}
