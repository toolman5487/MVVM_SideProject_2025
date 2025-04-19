//
//  HomeView.swift
//  MVVM_SideProject
//
//  Created by Willy Hsu on 2025/4/14.
//

import Foundation
import UIKit
import SnapKit
import Combine

class HomeView:UIViewController{
    
    private let homeViewModel = HomeViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.image = UIImage(systemName: "person.crop.circle")
        imageView.tintColor = .white
        return imageView
    }()
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "User ID"
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        label.textColor = .gray
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "User Email"
        return label
    }()
    
    private lazy var vUserStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [ idLabel, emailLabel])
        stack.axis = .vertical
        stack.spacing = 5
        stack.distribution = .fillProportionally
        stack.backgroundColor = .secondarySystemBackground
        stack.layer.cornerRadius = 10
        stack.layer.masksToBounds = true
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return stack
    }()
    
    
    private func layout(){
        view.addSubview(avatarImageView)
        view.addSubview(vUserStackView)
        
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        vUserStackView.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            
        }
        
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "首頁"
    }
    
    func bind(){
        homeViewModel.$homeModel
            .compactMap {$0}
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                self?.idLabel.text = model.user.uid ?? "使用者ID"
                self?.emailLabel.text = model.user.email ?? "使用者 Email"
                if let photoURL = model.user.photoURL{
                    self?.loadImage(from: photoURL)
                }
            }.store(in: &cancellables)
    }
    
    private func loadImage(from url: URL){
        URLSession.shared.dataTask(with: url){ data,response,error in
            if let data = data, let image = UIImage(data: data){
                DispatchQueue.main.async {
                    self.avatarImageView.image = image
                }
            }else{return}
        }.resume()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        bind()
        setupNavigationBar()
    }
}
