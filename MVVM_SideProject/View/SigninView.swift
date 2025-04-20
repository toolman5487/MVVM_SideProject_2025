//
//  LoginView.swift
//  MVVM_SideProject
//
//  Created by Willy Hsu on 2025/4/11.
//

import Foundation
import UIKit
import Combine
import CombineCocoa
import SnapKit

class SigninView:UIViewController{
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "登入"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    private let horizentalLine:UIView = {
        let view = UIView()
        view.backgroundColor =  .black
        view.addCornerRadius(radius: 2)
        return view
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "輸入 Email"
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 10
        textField.autocapitalizationType = .none
        textField.text = "willy548798@gmail.com"
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "輸入密碼"
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 10
        textField.isSecureTextEntry = true
        textField.text = "willy861031"
        return textField
    }()
    
    private lazy var textFieldVStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            emailTextField,
            passwordTextField
        ])
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let signinButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("確認", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .secondarySystemBackground
        return button
    }()
    
    private lazy var vStack: UIStackView = {
        let stack  = UIStackView(arrangedSubviews: [
            headerLabel,
            textFieldVStack,
        ])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.backgroundColor = .secondarySystemBackground
        stack.layer.cornerRadius = 10
        stack.layer.masksToBounds = true
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return stack
    }()
    
    private func layout(){
        view.addSubview(vStack)
        vStack.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(14)
            make.trailing.equalToSuperview().offset(-14)
        }
        textFieldVStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        view.addSubview(signinButton)
        signinButton.snp.makeConstraints { make in
            make.top.equalTo(vStack.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    private let loginVM = LoginViewModel()
    
    private func bind(){
        emailTextField.textPublisher
            .compactMap{$0}
            .assign(to: \.email , on: loginVM)
            .store(in: &cancellables)
        
        passwordTextField.textPublisher
            .compactMap {$0}
            .assign(to: \.password, on: loginVM)
            .store(in: &cancellables)
        
        signinButton.tapPublisher
            .sink { [weak self] _ in
                self?.loginVM.signIn()
            }
            .store(in: &cancellables)
        
        loginVM.$errorMessage
            .compactMap {$0}
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                self?.showAlert( message: errorMessage)
            }.store(in: &cancellables)
        
        loginVM.$isAuthenticated
            .filter { $0 == true }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                print("登入成功")
                if let user = self?.loginVM.getCurrentUser() {
                    print("使用者 UID: \(user.uid)")
                    print("Email: \(user.email ?? "無 Email")")
                    print("Display Name: \(user.displayName ?? "無姓名")")
                    print("PhotoRL: \(user.photoURL ?? URL(string: "No_URL")!)")
                    if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                        sceneDelegate.switchToMainTabBarController()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Login Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "登入/註冊"
    }
    
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        bind()
        setupNavigationBar()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        
    }
    
}
