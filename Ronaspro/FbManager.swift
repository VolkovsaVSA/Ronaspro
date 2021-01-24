//
//  FbManager.swift
//  Ronaspro
//
//  Created by Sergey Volkov on 24.01.2021.
//

import Foundation
import FirebaseAuth


class FbManager {
    static let shared = FbManager()
    
    var currentUser: User?
    
    func registrUserWithEmail(email: String, password: String, repeatPassword: String, completion: @escaping (User?, String)->Void) {
        
        guard !email.isEmpty else {completion(nil, "Не заполнен email"); return}
        guard !password.isEmpty && !repeatPassword.isEmpty && (password == repeatPassword) else {completion(nil, "Пароли не совпадают"); return}
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let result = authResult {
                completion(result.user, "Пользователь успешно содан")
            }
            if let createError = error {
                completion(nil, "Ошибка создания пользователя (\(createError.localizedDescription)). Попробцйте позже.")
            }
        }
        
        
       
    }
    
    func singIn(email: String, password: String, completion: @escaping (User?, Error?)->Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            completion(result?.user, error)
        }
    }
    
    func logOut(completion: @escaping (Result<String, Error>)->Void) {
        do {
            try Auth.auth().signOut()
            completion(.success("success"))
            currentUser = nil
        } catch {
            completion(.failure(error))
        }
    }
}
