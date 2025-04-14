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
        LabelFactory.build(text: "Login", font: ThemeFont.bold(ofSize: 24))
    }()
    
    private let horizentalLine:UIView = {
        let view = UIView()
        view.backgroundColor =  .black
        view.addCornerRadius(radius: 2)
        return view
    }()
    
    private let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter Email"
        tf.borderStyle = .roundedRect
        tf.layer.cornerRadius = 10
        tf.autocapitalizationType = .none
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter Password"
        tf.borderStyle = .roundedRect
        tf.layer.cornerRadius = 10
        tf.isSecureTextEntry = true
        return tf
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
        let btn = UIButton(type: .system)
        btn.setTitle("Log In", for: .normal)
        btn.backgroundColor = .black
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    private lazy var vStack: UIStackView = {
        let stack  = UIStackView(arrangedSubviews: [
            headerLabel,
            horizentalLine,
            textFieldVStack,
            signinButton
        ])
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    private let signinContainView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addCornerRadius(radius: 10.0)
        view.addShadow(
            offset: CGSize(width: 0, height: 3),
            color: UIColor.black,
            radius: 12.0,
            opacity: 0.1)
        return view
    }()
    
    private func layout(){
        view.addSubview(signinContainView)
        signinContainView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(view.snp.leading).offset(14)
            make.trailing.equalTo(view.snp.trailing).offset(-14)
        }
        
        signinContainView.addSubview(vStack)
        
        horizentalLine.snp.makeConstraints { make in
            make.height.equalTo(2)
        }
        
        vStack.setCustomSpacing(30, after: horizentalLine)
        
        signinButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(14)
            make.trailing.equalToSuperview().offset(-14)
        }
        
        vStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.bottom.equalToSuperview().offset(-14)
            make.leading.equalToSuperview().offset(14)
            make.trailing.equalToSuperview().offset(-14)
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
                    if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                        sceneDelegate.switchToHomeViewController()
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
    
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    private func navigationSetting(){
        navigationItem.title = "Log In"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 30, weight: .bold)
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        bind()
        navigationSetting()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        
    }
    
}
