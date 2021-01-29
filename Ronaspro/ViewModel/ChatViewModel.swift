//
//  ChatViewModel.swift
//  Ronaspro
//
//  Created by Sergey Volkov on 28.01.2021.
//

import Foundation

class ChatViewModel: ObservableObject {
    @Published var messages = [ChatMessageModel]()
}
