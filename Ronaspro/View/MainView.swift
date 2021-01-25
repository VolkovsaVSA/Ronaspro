//
//  MainView.swift
//  Ronaspro
//
//  Created by Sergey Volkov on 24.01.2021.
//

import SwiftUI

struct MainView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    let screenWidth = UIScreen.main.bounds.width
    let logoSize: CGFloat = 26

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
                ProfileView(user: FbManager.Authenticaton.currentUser!)
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
                    
                    leading:
                        BigLogoView(width: logoSize, height: logoSize, font: Font.system(size: 10), textPadding: 0, textLogo: "РОНАСМЕТЫ")
                        .offset(x: screenWidth/2 - logoSize * 2)
                       ,
                    trailing:
                        Button("Logout") {
                            FbManager.Authenticaton.logOut { result in
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

