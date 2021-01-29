//
//  AnswerView.swift
//  Ronaspro
//
//  Created by Sergey Volkov on 26.01.2021.
//

import SwiftUI

fileprivate var tsfileUrl: URL?

struct AnswerView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    private let defaultRow = (workName: "Заполняется работником",workCost: "0.0")
    
    var task: TaskModel
    @ObservedObject var answer = AnswerViewModel.shared
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @State private var showQLController = false
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Проект:  \(task.title)")
                    .font(.title3)
                Text("Описание: \(task.description)")
                    .fontWeight(.thin)
                    .multilineTextAlignment(.leading)
                Text("Выполнить до: \(DateFormatter.localizedString(from: task.dateEnd, dateStyle: .medium, timeStyle: .medium))")
                Text("Файлы:")
                    .fontWeight(.thin)
                
                ForEach(Array(task.files), id: \.self) { file in
                    
                    Button(action: {
                        
                        FbFileManager.downloadFile(taskID: task.id, fileName: file) { (url, error) in
                            if let localUrl = url {
                                tsfileUrl = localUrl
                                if tsfileUrl != nil {
                                    showQLController = true
                                }
                            }
                        }
                        
                    }, label: {
                        Text(file)
                            .font(.system(size: 12, weight: .thin, design: .default))
                            .padding(6)
                            .background(AppSettings.accentColor.opacity(0.5))
                            .cornerRadius(6)
                            .shadow(color: Color(UIColor.tertiaryLabel), radius: 4, x: 4, y: 4)
                    })
                    .foregroundColor(Color.white)
                    
                    
                }
                    
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Работы по проекту:")
                    .padding(.top)
                Divider()
                VStack {
                    HStack {
                        Text("Наименование работ")
                            .fontWeight(.bold)
                        Spacer()
                        Text("Стоимость")
                            .fontWeight(.bold)
                    }
                }
            }
            .padding(.horizontal)
            
            List {
                ForEach(AnswerViewModel.shared.workNames.indices, id:\.self) { index in
                    HStack {
                        TextField(defaultRow.workName, text: $answer.workNames[index])
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: AppSettings.screenWidth * (3/4))
                        Spacer()
                        TextField(defaultRow.workCost, text: $answer.workCosts[index])
                            .multilineTextAlignment(.trailing)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: AppSettings.screenWidth * (1/4))
                        
                    }
                }
                .onDelete(perform: { indexSet in
                    answer.workNames.remove(atOffsets: indexSet)
                    answer.workCosts.remove(atOffsets: indexSet)
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .listRowInsets(EdgeInsets())
                .background(Color.white)
                
                Button(action: {
                    withAnimation {
                        answer.addRow()
                    }
                }, label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Добавить строку")
                    }
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .listRowInsets(EdgeInsets())
                .background(Color.white)
                
            }
            
            //.listStyle(SidebarListStyle())
            .padding(.horizontal)
            //.listStyle(PlainListStyle())
            HStack {
                Text("Итогавая стоимость")
                Spacer()
                Text(answer.totalCost().description)
            }
            .padding()
            .font(.system(size: 20, weight: .bold, design: .default))
            
        }
        .navigationBarTitle("Расчёт стоимости")
        .navigationBarItems(
            trailing:
                
                Button(action: {
                    FbManager.Docs.createAnswer(answer:
                                        TaskAnswerModel(
                                            id: UUID().uuidString,
                                            parentTask: task.id,
                                            totalCost: answer.totalCost(),
                                            workNames: answer.workNames,
                                            workCosts: answer.costsInDouble,
                                            responsibleID: FbManager.Authenticaton.currentUser!.id,
                                            responsibleName: FbManager.Authenticaton.currentUser!.name,
                                            responsibleEmail: FbManager.Authenticaton.currentUser!.email,
                                            responsibleStaffPositon: FbManager.Authenticaton.currentUser!.staffPositon)) { error in
                        if let answerError = error {
                            alertTitle = "Ошибка отправки расчёта"
                            alertMessage = answerError.localizedDescription
                        } else {
                            alertTitle = "Успешно"
                            alertMessage = "Расчёт отправлен!"
                        }
                        showAlert = true
                    }
                    
                }, label: {
                    Image(systemName: "checkmark.square.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                })
            
        )
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK"), action: {
                presentationMode.wrappedValue.dismiss()
            }))
        })
        .sheet(isPresented: $showQLController) {
            //guard tsfileUrl != nil else {print(#line); return}
            QuickLookController(url: tsfileUrl!) {
                
            }
        }
        
    }
}
