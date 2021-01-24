//
//  RonasproApp.swift
//  Ronaspro
//
//  Created by Sergey Volkov on 24.01.2021.
//

import SwiftUI

@main
struct RonasproApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
