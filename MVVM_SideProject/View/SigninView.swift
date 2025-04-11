//
//  LoginView.swift
//  MVVM_SideProject
//
//  Created by Willy Hsu on 2025/4/11.
//

import Foundation
import UIKit
import Combine
import SnapKit

class SigninView:UIViewController{
    
    private let headerLabel: UILabel = {
        LabelFactory.build(text: "帳號登入", font: ThemeFont.demiBold(Ofsize: 30))
    }()
    
    private let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "輸入 Email"
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "輸入密碼"
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("登入", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 5
        return btn
    }()
    
    private lazy var vStack: UIStackView = {
        let stack  = UIStackView(arrangedSubviews: [
            headerLabel,
            emailTextField,
            passwordTextField,
            loginButton
        ])
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let loginContainView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addCornerRadius(radius: 8.0)
        view.addShadow(
            offset: CGSize(width: 0, height: 3),
            color: UIColor.black,
            radius: 12.0,
            opacity: 0.1)
        return view
    }()
    
    private func layout(){
        view.addSubview(loginContainView)
        loginContainView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(view.snp.leading).offset(14)
            make.trailing.equalTo(view.snp.trailing).offset(-14)
            
        }
        
        loginContainView.addSubview(vStack)
        vStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.bottom.equalToSuperview().offset(-14)
            make.leading.equalToSuperview().offset(14)
            make.trailing.equalToSuperview().offset(-14)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    
}
