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
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "User Name"
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textColor = .gray
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "User Email"
        return label
    }()
    
    private lazy var vUserStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ nameLabel, emailLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    
    private func layout(){
        view.addSubview(avatarImageView)
        view.addSubview(vUserStackView)
        
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        vUserStackView.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
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
                self?.nameLabel.text = model.user.displayName ?? "使用者名稱"
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
