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
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        bind()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
}
