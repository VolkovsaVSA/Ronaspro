//
//  AnswerView.swift
//  Ronaspro
//
//  Created by Sergey Volkov on 26.01.2021.
//

import SwiftUI

struct AnswerView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    private let defaultRow = (workName: "Заполняется работником",workCost: "0.0")
    
    var task: TaskModel
    @ObservedObject var answer = AnswerViewModel.shared
    
    @State var showAlert = false
    @State var alertTitle = ""
    @State var alertMessage = ""
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Проект:  \(task.title)")
                    .font(.title3)
                Text("Описание: \(task.description)")
                    .fontWeight(.thin)
                    .multilineTextAlignment(.leading)
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
                    
                    FbManager.Docs.createAnswer(answer: TaskAnswerModel(id: UUID().uuidString, parentTask: task.id, responsibleID: FbManager.Authenticaton.currentUser!.id, totalCost: answer.totalCost(), workNames: answer.workNames, workCosts: answer.costsInDouble)) { error in
                        
                        
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
        
        
    }
}

struct AnswerView_Previews: PreviewProvider {
    static var previews: some View {
        AnswerView(task: TaskModel(id: "1", title: "Проект Х", description: "Что-то очень важное", ownerID: "xxx", dateAdded: Date(), responsibles: [], answers: ["x":"x"], totalCost: 0))
    }
}
