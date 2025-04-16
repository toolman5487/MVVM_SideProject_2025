//
//  MovieView.swift
//  MVVM_SideProject
//
//  Created by Willy Hsu on 2025/4/16.
//

import Foundation
import UIKit
import SnapKit

class MovieView:UIViewController{
    
    let label:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .label
        label.text = "Hello Movie"
        return label
    }()
    
    func layout(){
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "電影"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        setupNavigationBar()
    }
}
