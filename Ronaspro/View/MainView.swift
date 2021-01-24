//
//  MainView.swift
//  Ronaspro
//
//  Created by Sergey Volkov on 24.01.2021.
//

import SwiftUI

struct MainView: View {
    
    @Environment(\.presentationMode) private var presentationMode

    @State var selectedTab = 1
    
    var body: some View {
        
        NavigationView {
            
            TabView(selection: $selectedTab) {
                Text("Page1")
                    .tabItem {
                        Image(systemName: "list.dash")
                        Text("Проекты")
                    }
                    .tag(0)
                Text(FbManager.shared.currentUser?.email ?? "no user")
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Профиль")
                    }
                    .tag(1)
                Text("Page3")
                    .tabItem {
                        Image(systemName: "envelope.fill")
                        Text("Сообщения")
                    }
                    .tag(2)
            }

                .navigationBarItems(
                    
                    trailing:
                        Button("Logout") {
                            FbManager.shared.logOut { result in
                                switch result {
                                case .success(_):
                                    presentationMode.wrappedValue.dismiss()
                                case .failure(let error):
                                    print(error.localizedDescription)
                                }
                            }
                            
                        }
                    
                )
            
        }
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
