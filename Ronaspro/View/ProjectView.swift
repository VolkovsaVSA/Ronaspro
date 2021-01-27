//
//  MessageView.swift
//  Ronaspro
//
//  Created by Sergey Volkov on 25.01.2021.
//

import SwiftUI


struct ProjectView: View {
    
    @State var userTasks = [TaskModel]()
    @State var errorsMessage = ""
    @State private var getTaskBool = false
   
    fileprivate func getTasks() {
        if FbManager.Authenticaton.currentUser!.staffPositon == .manager {
            FbManager.Docs.addProjectListenerOwner(id: FbManager.Authenticaton.currentUser!.id) { (tasks, error) in
                
                userTasks = tasks
                if let taskError = error {
                    errorsMessage = taskError.localizedDescription
                }
            }
        } else {
            FbManager.Docs.addProjectListenerResponsible(id: FbManager.Authenticaton.currentUser!.id) { (tasks, error) in

                userTasks = tasks
                if let taskError = error {
                    errorsMessage = taskError.localizedDescription
                }
            }
        }
    }
    fileprivate func calcTaskTotalProgress(task: TaskModel)->Int {
        return  Int(round((Double(task.answers.count) / Double(task.responsibles.count)) * 100))
    }
    fileprivate func createProjectDetail(task: TaskModel)-> AnyView {
        if FbManager.Authenticaton.currentUser!.staffPositon == .manager {
            return AnyView(ReportView(task: task))
        } else {
            var answerView = AnyView(AnswerView(task: task))
            if checkAnswer(task: task) {
                answerView = AnyView(Text("Вы отправили расчёт"))
            }
            return answerView
        }
    }
    fileprivate func checkAnswer(task: TaskModel)->Bool {
        var check = false
        task.answers.forEach { answer in
            if answer.value == FbManager.Authenticaton.currentUser!.id {
                check = true
            }
        }
        return check
    }
    
    
    
    
    var body: some View {
        
        
        ScrollView {
            ForEach(userTasks, id:\.id) { task in
                NavigationLink(
                    destination: createProjectDetail(task: task),
                    label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(DateFormatter.localizedString(from: task.dateAdded, dateStyle: .medium, timeStyle: .short))
                                    .font(.system(size: 10))
                                    .fontWeight(.thin)
                                Text("Проект \"\(task.title)\"")
                                    .fontWeight(.medium)
                                Text("Описание: \(task.description)")
                                    .font(.system(size: 12))
                                    .fontWeight(.thin)
                            }
                            .foregroundColor(Color(UIColor.label))
                            Spacer()
                            
                            if FbManager.Authenticaton.currentUser!.staffPositon == .manager {
                                Text("\(calcTaskTotalProgress(task: task))%" )
                                    .font(.system(size: 16))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(UIColor.label))
                            } else {
                                if checkAnswer(task: task) {
                                    IconImageView(image: "checkmark.circle.fill", color: Color.green, imageScale: 30)
                                        .shadow(color: Color(UIColor.tertiaryLabel), radius: 4, x: 4, y: 4)
                                        .padding(.trailing, 10)
                                } else {
                                    IconImageView(image: "exclamationmark.circle.fill", color: Color.yellow, imageScale: 30)
                                        .shadow(color: Color(UIColor.tertiaryLabel), radius: 4, x: 4, y: 4)
                                        .padding(.trailing, 10)
                                }
                            }
                            
                        }
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(Color(UIColor.secondarySystemBackground))
                        )
                        .clipped()
                        .shadow(color: Color(UIColor.tertiaryLabel), radius: 4, x: 4, y: 4)
                    })
                    .padding()
            }
        }
        
        .onAppear() {
            if !getTaskBool {
                getTasks()
                getTaskBool = true
            }
        }
    }
    
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectView()
    }
}
