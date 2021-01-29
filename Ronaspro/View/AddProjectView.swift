//
//  AddTaskView.swift
//  Ronaspro
//
//  Created by Sergey Volkov on 25.01.2021.
//

import SwiftUI


struct AddProjectView: View {
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State var taskTitle = ""
    @State var taskText = "Добавьте описание"
    @State var files = [String]()
    @State var allUsers = [MyUserModel]()
    @State var responsibles = Set<String>()
    @State private var editMode = EditMode.inactive
    
    @State private var alertMessage = (title: "", message: "")
    @State private var showAlert = false
    
    @State private var startDate = Date()
    @State private var endDate = Date()
   
    var body: some View {
        
        NavigationView {
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Заголовок")
                        .font(.title2)
                        .fontWeight(.bold)
                    TextField("Введите заголовок проекта", text: $taskTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text("Описание")
                        .font(.title2)
                        .fontWeight(.bold)
                    TextEditor(text: $taskText)
                        .frame(height: 50, alignment: .leading)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color(#colorLiteral(red: 0.921477735, green: 0.9216321707, blue: 0.9214574099, alpha: 1)), lineWidth: 1)
                        )
                        .foregroundColor(taskText == "Добавьте описание" ? Color(#colorLiteral(red: 0.7685510516, green: 0.768681407, blue: 0.7771411538, alpha: 1)) : .primary)
                    DatePicker(selection: $startDate, in: Date()..., displayedComponents: [.date, .hourAndMinute]) {
                        Text("Начало")
                            .fontWeight(.thin)
                    }
                    DatePicker(selection: $endDate, in: Date()..., displayedComponents: [.date, .hourAndMinute]) {
                        Text("Завершение")
                            .fontWeight(.thin)
                    }
                    Text("Файлы")
                        .font(.title2)
                        .fontWeight(.bold)
                    HStack {
                        VStack {
                            Text("Нет файлов")
                                .fontWeight(.thin)
                        }
                        Spacer()
                        Button(action: {
                            
                            
                            
                        }, label: {
                            Image(systemName: "doc.badge.plus")
                                .resizable()
                                .frame(width: 22, height: 24, alignment: .center)
                                .foregroundColor(.accentColor)
                            
                        })
                    }
                }
                .onTapGesture {
                    self.endEditing(true)
                }
                .padding()
                
                VStack {
                    HStack {
                        Text("Отвественные")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        Button(action: {
                            if editMode == .inactive {
                                editMode = .active
                            } else {
                                editMode = .inactive
                                
                            }

                        }, label: {
                            if editMode == .active {
                                Image(systemName: "checkmark.square")
                                    .resizable()
                                    .frame(width: 20, height: 20, alignment: .center)
                                    .foregroundColor(.accentColor)
                            } else {
                                Image(systemName: "plus.app.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20, alignment: .center)
                                    .foregroundColor(.accentColor)
                            }
                            
                        })
                        
                    }
                    .padding(.horizontal)
                    
                    List(allUsers, id:\.id, selection: $responsibles) { user in
                        HStack {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(user.name)
                                HStack {
                                    Text(user.email)
                                    Spacer()
                                    Text(user.staffPositon.rawValue)
                                }
                                .font(.system(size: 16, weight: .thin, design: .default))
                            }
                            Spacer()
                            if responsibles.contains(user.id) {
                                Image(systemName: "checkmark")
                                    .resizable()
                                    .frame(width: 16, height: 16, alignment: .center)
                                    .foregroundColor(.blue)
                            }
                            
                        }
                    }
                    .listStyle(PlainListStyle())
                    
                    
                }
                
                Spacer()
            }
            .edgesIgnoringSafeArea(.bottom)
            .onTapGesture {
                self.endEditing(true)
            }
            .navigationBarTitle("Создание проекта", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.backward")
                }),
                                
                trailing: Button(action: {
                    
                    let task = TaskModel(id: UUID().uuidString,
                                         title: taskTitle,
                                         description: taskText,
                                         ownerID: FbManager.Authenticaton.currentUser!.id,
                                         dateAdded: startDate,
                                         dateEnd: endDate,
                                         responsibles: Array(responsibles),
                                         answers: [:],
                                         totalCost: 0)
                    
                    FbManager.Docs.createTask(task: task) {  (title, message)  in
                        alertMessage = (title, message)
                        showAlert = true
                    }
                    
                }, label: {
                    Image(systemName: "checkmark.square.fill")
                        .resizable()
                        .frame(width: 20, height: 20, alignment: .center)
                        .foregroundColor(.accentColor)
                }))
            .environment(\.editMode, $editMode)
        }
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text(alertMessage.title),
                  message: Text(alertMessage.message),
                  dismissButton: .default(Text("OK"), action: {
                    if alertMessage.title == "Успешно" {
                        presentationMode.wrappedValue.dismiss()
                    }
                  }))
        })
        .onAppear {
            // remove the placeholder text when keyboard appears
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (noti) in
                withAnimation {
                    if taskText == "Добавьте описание" {
                        taskText = ""
                    }
                }
            }
            // put back the placeholder text if the user dismisses the keyboard without adding any text
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
                withAnimation {
                    if taskText == "" {
                        taskText = "Добавьте описание"
                    }
                }
            }
            
            FbManager.Docs.getAllUsers { users in
                allUsers = users
            }
            
        }
        
    }
    
}
