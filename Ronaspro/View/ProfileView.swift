//
//  ProfileView.swift
//  Ronaspro
//
//  Created by Sergey Volkov on 25.01.2021.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    
    @State var user: MyUserModel
    
    var body: some View {
        VStack {
            Text(user.staffPositon.rawValue)
                .font(.title2)
                .padding()
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 150, height: 150, alignment: .center)
                .foregroundColor(.secondary)
            
            Text(user.name)
                .font(.largeTitle)
                .padding()
            Text(user.email)
            Spacer()
        }
    }
}


