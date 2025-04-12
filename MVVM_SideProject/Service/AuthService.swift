//
//  AuthService.swift
//  MVVM_SideProject
//
//  Created by Willy Hsu on 2025/4/12.
//

import Foundation
import FirebaseAuth
import Combine

protocol AuthServiceProtocol {
    func signIn(email: String, password: String) -> AnyPublisher<Void, Error>
}

class FirebaseAuthService: AuthServiceProtocol {
    func signIn(email: String, password: String) -> AnyPublisher<Void, any Error> {
        
    }
}
