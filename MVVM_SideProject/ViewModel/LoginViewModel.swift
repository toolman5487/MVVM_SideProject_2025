//
//  LoginViewModel.swift
//  MVVM_SideProject
//
//  Created by Willy Hsu on 2025/4/12.
//

import Foundation
import Combine
import FirebaseAuth


class LoginViewModel:ObservableObject{
    
    @Published var email:String = ""
    @Published var password:String = ""
    @Published private(set) var isAuthenticated: Bool = false
    @Published private(set) var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol = FirebaseAuthService()) {
        self.authService = authService
    }
    
    func signIn() {
        authService.signIn(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                    self?.isAuthenticated = false
                }
            } receiveValue: { [weak self] in
                self?.isAuthenticated = true
                self?.errorMessage = nil
            }
            .store(in: &cancellables)
    }
    
    func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
    
}
