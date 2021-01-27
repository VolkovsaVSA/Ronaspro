//
//  ReportView.swift
//  Ronaspro
//
//  Created by Sergey Volkov on 27.01.2021.
//

import SwiftUI

struct ReportView: View {
    
    @State var task: TaskModel
    
    @State var taskAnswers = [TaskAnswerModel]()
    @State var totalCost = 0.0
    
    var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("tabBarColor").opacity(0.1), Color("tabBarColor").opacity(0.5)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                //            Color(UIColor(red: 0.831, green: 0.82, blue: 0.847, alpha: 1))
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 10) {
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Проект:")
                            .fontWeight(.bold)
                        Text(task.title)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    HStack {
                        Text("Описание:")
                            .fontWeight(.thin)
                        Text(task.description)
                            .fontWeight(.thin)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Сроки")
                        .fontWeight(.bold)
                    HStack {
                        Text("Начало:")
                            .fontWeight(.thin)
                        Text(DateFormatter.localizedString(from: task.dateAdded, dateStyle: .medium, timeStyle: .medium))
                            .fontWeight(.thin)
                        Spacer()
                    }
                    HStack {
                        Text("Окончание:")
                            .fontWeight(.thin)
                        Text(DateFormatter.localizedString(from: task.dateEnd, dateStyle: .medium, timeStyle: .medium))
                            .fontWeight(.thin)
                        Spacer()
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Расчёты")
                        .fontWeight(.bold)
                    HStack {
                        Text("Общая стоимость")
                            .fontWeight(.thin)
                        Spacer()
                        Text(totalCost.description)
                            .fontWeight(.bold)
                        
                    }
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Работы")
                        .fontWeight(.bold)
                    ScrollView {
                        ForEach(taskAnswers, id:\.self) { answer in
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(answer.responsibleName)
                                        .fontWeight(.semibold)
                                    Text(answer.responsibleStaffPositon.rawValue)
                                        .fontWeight(.thin)
                                }
                                Spacer()
                                Text(answer.totalCost.description)
                            }
                            .padding(.bottom, 8)
                        }
                        
                    }

                }
                
                Spacer()
                
            }
            .padding()
            
            
        }
        .navigationTitle("Смета проекта")
        .onAppear() {
            FbManager.Docs.getAnswers(task: task) { (answers, error) in
                print(answers.description)
                taskAnswers = answers
                totalCost = 0.0
                answers.forEach { ans in
                    totalCost += ans.totalCost
                }
//                FbManager.db.collection(FbManager.Collections.projects.rawValue).document(task.id)
//                    .updateData([FbManager.TaskFileds.totalCost.rawValue : totalCost])
            }
        }
    }
}
