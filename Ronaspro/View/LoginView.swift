
//  Created by Sergey Volkov on 24.01.2021.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    
    @State var name = ""
    @State var email = ""
    @State var password = ""
    @State var repeatPassword = ""
    @State var hidePass = true
    @State var showMainView = false
    @State var registrationForm = false
    
    @State var alertMessage = ""
    @State var showAlert = false
    
    private func createUser() {
        FbManager.shared.registrUserWithEmail(email: email, password: password, repeatPassword: repeatPassword) { (user, message) in
            if let currentUser = user {
                FbManager.shared.currentUser = currentUser
            }
            alertMessage = message
            showAlert = true
        }
    }
    
    private func singIn() {
        FbManager.shared.singIn(email: email, password: password) { (user, _) in
            if let currentUser = user {
                FbManager.shared.currentUser = currentUser
                showMainView = true
            }
        }
    }
    
    
    
    
    var body: some View {
        
        VStack {

            BigLogoView(width: 100, height: 100, font: .title2, textPadding: 4)
            .padding(.vertical, 60)
            
            VStack(spacing: 12) {
                InputTextView(title: "E-mail",
                              titleDescription: "Введите адрес электронной почты",
                              keyboardType: .emailAddress,
                              autocapitalization: .none,
                              text: $email)
                InputPasswordView(title: "Пароль",
                                  titleDescription: "Введите пароль", hidePass: hidePass, password: $password)
                if registrationForm {
                    InputPasswordView(title: "Повторите пароль",
                                      titleDescription: "Повторно введите пароль", hidePass: hidePass, password: $repeatPassword)
                    InputTextView(title: "Имя",
                                  titleDescription: "Введите своё имя",
                                  keyboardType: .default,
                                  autocapitalization: .sentences,
                                  text: $name)
                }
                
                
            }
            HStack {
                Spacer()
                VStack(alignment: .trailing, spacing: 6) {
                    Button("OK") {
                        if registrationForm {
                            createUser()
                        } else {
                            singIn()
                        }
                        
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
            HStack(spacing:2) {
                Button(action: {
                    withAnimation(Animation.spring()) {
                        registrationForm = true
                    }
                }, label: {
                    Text("Регистрация")
                        .underline(registrationForm)
                        .foregroundColor(registrationForm ? Color.init(red: 255/255, green: 76/255, blue: 60/255) : Color(UIColor.label))
                        .font(.system(size: 15, weight: .light, design: .default))
                })
                Text("/")
                Button(action: {
                    withAnimation(Animation.spring()) {
                        registrationForm = false
                    }
                }, label: {
                    Text("Вход")
                        .underline(!registrationForm)
                        .foregroundColor(!registrationForm ? Color.init(red: 255/255, green: 76/255, blue: 60/255) : Color(UIColor.label))
                        .font(.system(size: 15, weight: .light, design: .default))
                })
            }
            
            
        }
        .padding([.horizontal], 30)
        .fullScreenCover(isPresented: $showMainView, content: {
            MainView()
        })
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text(FbManager.shared.currentUser != nil ? "Успех" : "Ошибка"),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("OK"), action: {
                    if FbManager.shared.currentUser != nil {
                        showMainView = true
                    }
                  }))
        })
        .onAppear() {
            if Auth.auth().currentUser != nil {
                FbManager.shared.currentUser = Auth.auth().currentUser
                showMainView = true
            }
        }
            
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
