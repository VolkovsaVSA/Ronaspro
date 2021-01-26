
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
    @State var registrationForm = false
    
    @State var alertMessage = ""
    @State var showAlert = false
    
    @State var stafPosition = StaffPosition.manager
   
    @State private var sheet: ActiveSheet?
    
    private func createUser() {
        FbManager.Authenticaton.registrUserWithEmail(name: name, email: email, password: password, repeatPassword: repeatPassword, staffPosition: stafPosition) { (user, message) in
            if let currentUser = user {
                
                FbManager.Docs.getUserData(id: currentUser.uid) { err in
                    if let userError = err {
                        alertMessage = userError.localizedDescription
                    }
                    
                    alertMessage = message
                    showAlert = true
                }
                
            }
            
        }
    }
    
    private func singIn() {
        FbManager.Authenticaton.singIn(email: email, password: password) { (user, error) in
            
            if let currentUser = user {
                
                FbManager.Docs.getUserData(id: currentUser.uid) { err in
                    if let userError = err {
                        alertMessage = userError.localizedDescription
                        showAlert = true
                    } else {
                        //FbManager.Authenticaton.currentUser = currentUser
                        sheet = .showMainView
                    }
                }
                
                
            } else {
                alertMessage = error!.localizedDescription
                showAlert = true
            }
        }
    }
    
    
    
    
    var body: some View {
        
        VStack {

            BigLogoView(width: 100, height: 100, font: .title2, textPadding: 4, textLogo: "РОНАСПРРО")
            .padding(.vertical, 40)
            
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
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Должность")
                            .font(.system(size: 12, weight: .regular, design: .default))
                       
                        Button(action: {
                            sheet = .staffPositionList
                        }, label: {
                            Text(stafPosition.rawValue)
                        })
                        Divider()
                    }
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
                    .background(Color.accentColor)
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
                        FbManager.Authenticaton.currentUser = nil
                        registrationForm = true
                    }
                }, label: {
                    Text("Регистрация")
                        .underline(registrationForm)
                        .foregroundColor(registrationForm ? Color.accentColor : Color(UIColor.label))
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
                        .foregroundColor(!registrationForm ? Color.accentColor : Color(UIColor.label))
                        .font(.system(size: 15, weight: .light, design: .default))
                })
            }
            
            
        }
        .padding([.horizontal], 30)
        .fullScreenCover(item: $sheet) { item in
            switch item {
            case .staffPositionList:
                StaffPositionListView(poistion: $stafPosition)
            case .showMainView:
                MainView()
            }
        }
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text(FbManager.Authenticaton.currentUser != nil ? "Успех" : "Ошибка"),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("OK"), action: {
                    if FbManager.Authenticaton.currentUser != nil {
                        sheet = .showMainView
                    }
                  }))
        })
        
        .onAppear() {
            if Auth.auth().currentUser != nil {
                FbManager.Docs.getUserData(id: Auth.auth().currentUser!.uid) { error in
                    if error == nil {
                        sheet = .showMainView
                    } else {
                        try? Auth.auth().signOut()
                    }
                }
                
            }
        }
            
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
