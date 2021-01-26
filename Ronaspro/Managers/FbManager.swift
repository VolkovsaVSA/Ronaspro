//
//  FbManager.swift
//  Ronaspro
//
//  Created by Sergey Volkov on 24.01.2021.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


struct FbManager {
    static let db = Firestore.firestore()
    
    enum Collections: String {
        case users, projects, answers
    }
    enum UserFileds: String {
        case id, email, name, staffPositon
    }
    enum TaskFileds: String {
        case id, title, description, ownerID, dateAdded, responsibles, answers, totalCost
    }
    enum AnswerFileds: String {
        case id, parentTask, responsibleID, totalCost, workNames, workCosts
    }
    
    
    struct Authenticaton {
        static var currentUser: MyUserModel? 
        
        static func registrUserWithEmail(name: String,
                                         email: String,
                                         password: String,
                                         repeatPassword: String,
                                         staffPosition: StaffPosition,
                                         completion: @escaping (User?, String)->Void) {
            
            guard !email.isEmpty else {
                completion(nil, "Не заполнен email")
                return
            }
            guard !password.isEmpty && !repeatPassword.isEmpty && (password == repeatPassword) else {
                completion(nil, "Пароли не совпадают")
                return
            }
            guard !name.isEmpty else {
                completion(nil, "Не заполнено имя")
                return
            }
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let result = authResult {
                    let changeRequest = result.user.createProfileChangeRequest()
                    changeRequest.displayName = name
                    changeRequest.commitChanges { (error) in
                        
                        if let setNameError = error {
                            completion(result.user, "Не удалось установить имя юзера: \(setNameError.localizedDescription)")
                        }
                        
                        let myUser = MyUserModel(id: result.user.uid,
                                                 email: email,
                                                 name: name,
                                                 staffPositon: staffPosition)
                        
                        FbManager.Docs.createUserData(user: myUser) { userError in
                            
                            if let userDataError = userError {
                                result.user.delete { _ in }
                                completion(nil, "Ошибка создания пользователя (\(userDataError.localizedDescription)). Попробцйте позже.")
                            } else {
                                completion(result.user, "Пользователь успешно содан")
                            }
                            
                        }
                        
                    }
                    
                }
                if let createError = error {
                    completion(nil, "Ошибка создания пользователя (\(createError.localizedDescription)). Попробцйте позже.")
                }
            }
            
            
           
        }
        
        static func singIn(email: String, password: String, completion: @escaping (User?, Error?)->Void) {
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                completion(result?.user, error)
            }
        }
        
        static func logOut(completion: @escaping (Result<String, Error>)->Void) {
            do {
                try Auth.auth().signOut()
                completion(.success("success"))
                currentUser = nil
                FbManager.Authenticaton.currentUser = nil
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    struct Docs {
        static func createUserData(user: MyUserModel, completion: @escaping (Error?)->Void) {
            db.collection(Collections.users.rawValue).document(user.id).setData(user.dictionary) { err in
                completion(err)
            }
        }
        static func getUserData(id: String, completion: @escaping (Error?)->Void) {
            db.collection(Collections.users.rawValue).document(id).getDocument { (snap, error) in
                if let data = snap?.data() {
                    FbManager.Authenticaton.currentUser = MyUserModel(dictionary: data)
                    //print(FbManager.Authenticaton.currentUser.debugDescription)
                }
                completion(error)
            }
        }
        static func getAllUsers(completion: @escaping ([MyUserModel])->Void) {
            db.collection(Collections.users.rawValue).getDocuments { (snapshot, error) in
                var users = [MyUserModel]()
                if let snaps = snapshot {
                    for doc in snaps.documents {
                        if let user = MyUserModel(dictionary: doc.data()) {
                            users.append(user)
                        }
                    }
                    completion(users)
                } else {
                    print("error: \(String(describing: error?.localizedDescription))")
                }
            }
        }
        static func createTask(task: TaskModel, completion: @escaping (_ title: String, _ message: String)->Void) {
            db.collection(Collections.projects.rawValue).document(task.id).setData(task.dictionary) { (error) in
                if let taskError = error {
                    completion("Ошибка", "Ошибка сохранения: \(taskError.localizedDescription). Повторите позже.")
                } else {
                    completion("Успешно", "Задача успешно сохранена и отправлена исполнителям.")
                }
            }
        }
        static func addProjectListenerResponsible(id: String, completion: @escaping ([TaskModel], Error?)->Void) {
            var tasks = [TaskModel]()
            db.collection(Collections.projects.rawValue)
                .whereField(FbManager.TaskFileds.responsibles.rawValue, arrayContains: id)
                .addSnapshotListener { (snapshot, error) in
                    let sem = DispatchSemaphore(value: 1)
                    if let snap = snapshot {
                        tasks = []
                        for x in snap.documents {
                            if let task = TaskModel(dictionary: x.data()) {
                                tasks.append(task)
                            }
                        }
                        sem.signal()
                    }
                    sem.wait()
                    completion(tasks, error)
                }
        }
        static func addProjectListenerOwner(id: String, completion: @escaping ([TaskModel], Error?)->Void) {
            var tasks = [TaskModel]()
            db.collection(Collections.projects.rawValue)
                .whereField(FbManager.TaskFileds.ownerID.rawValue, isEqualTo: id)
                .addSnapshotListener { (snapshot, error) in
                    let sem = DispatchSemaphore(value: 1)
                    if let snap = snapshot {
                        tasks = []
                        for x in snap.documents {
                            if let task = TaskModel(dictionary: x.data()) {
                                print("create task")
                                tasks.append(task)
                            }
                        }
                        print("tasks: \(tasks.description)")
                        sem.signal()
                    }
                    sem.wait()
                    completion(tasks, error)
                }
        }
        static func createAnswer(answer: TaskAnswerModel, completion: @escaping (Error?)->Void) {
            db.collection(Collections.answers.rawValue).document(answer.id).setData(answer.dictionary) { error in
                if let err = error {
                    completion(err)
                } else {
                    db.collection(Collections.projects.rawValue).document(answer.parentTask)
                        .updateData(["answers.\(answer.id)" : FbManager.Authenticaton.currentUser!.id])
                }
            }
        }
        
    }
}
