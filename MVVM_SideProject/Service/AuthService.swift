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
    
    func signIn(email: String, password: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    promise(.failure(error))
                } else if let _ = result?.user {
                    promise(.success(()))
                } else {
                    let unknownErr = NSError(domain: "FirebaseAuthService",
                                      code: -1,
                                      userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred."])
                    promise(.failure(unknownErr))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
