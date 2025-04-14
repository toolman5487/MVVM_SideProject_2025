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
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to the Home Page!"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private func layout(){
        view.backgroundColor = .white
        view.addSubview(welcomeLabel)
        
        welcomeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    private func navigationSetting(){
        navigationItem.title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 30, weight: .bold)
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        navigationSetting()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
    }
}
