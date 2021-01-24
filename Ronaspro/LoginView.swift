//
//  ContentView.swift
//  Shared
//
//  Created by Sergey Volkov on 24.01.2021.
//

import SwiftUI

struct LoginView: View {
    
    @State var login = ""
    @State var password = ""
    @State var hidePass = true
    
    var body: some View {
        VStack {
            
            VStack {
                Image("ronaspro")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100, alignment: .center)
                Text("РОНАСМЕТЫ")
                    .padding()
                    .foregroundColor(Color.init(red: 51/255, green: 47/255, blue: 93/255))
                    .font(.title2)
            }
            .padding(.top, 70)
            .padding(.bottom, 100)
            
            VStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("E-mail")
                        .font(.system(size: 12, weight: .regular, design: .default))
                    TextField("Введите адрес электронной почты", text: $login)
                    Divider()
                }
                VStack(alignment: .leading, spacing: 6) {
                    Text("Пароль")
                        .font(.system(size: 12, weight: .regular, design: .default))
                    HStack {
                        if hidePass {
                            SecureField("Введите пароль", text: $password) {
                                
                            }
                            .frame(height: 20)
                        } else {
                            TextField("Введите пароль", text: $password, onCommit:  {
                                
                            })
                            .frame(height: 20)
                        }
                        Button(action: {
                            hidePass.toggle()
                        }, label: {
                            Image(systemName: hidePass ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(hidePass ? Color.secondary : Color.green)
                        })
                    }
                    
                        
                    Divider()
                }
            }
            HStack {
                Spacer()
                VStack(alignment: .trailing, spacing: 6) {
                    Button("OK") {
                        print("ok button")
                    }
                    .frame(width: 48, height: 48, alignment: .center)
                    .background(Color.init(red: 51/255, green: 47/255, blue: 93/255))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    Text("Забыли пароль?")
                        .font(.system(size: 12, weight: .regular, design: .default))
                        .underline()
                }
                
            }
            Spacer()
            
            Button(action: {
                
            }, label: {
                Text("Регистрация")
                    .underline()
                    .foregroundColor(Color(UIColor.label))
                    .font(.system(size: 14, weight: .light, design: .default))
            })
            
        }
        .padding([.horizontal], 30)
        
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
