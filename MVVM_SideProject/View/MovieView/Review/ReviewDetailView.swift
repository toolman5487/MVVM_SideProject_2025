//
//  ReviewDetailView.swift
//  MVVM_SideProject
//
//  Created by Willy Hsu on 2025/5/1.
//

import Foundation
import UIKit
import SnapKit

class ReviewDetailViewController: UIViewController {
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.bold(ofSize: 20)
        label.textColor = .label
        return label
    }()
    
    private let avatarImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        return image
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.regular(ofSize: 16)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let createdAtLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.regular(ofSize: 12)
        label.textColor = .tertiaryLabel
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.regular(ofSize: 12)
        label.textColor = .label
        return label
    }()
    
    lazy var avatarStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [avatarImageView, authorLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.backgroundColor = .secondarySystemBackground
        stack.layer.cornerRadius = 10
        stack.layer.masksToBounds = true
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    lazy var contentStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [createdAtLabel, ratingLabel, contentLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.backgroundColor = .secondarySystemBackground
        stack.layer.cornerRadius = 10
        stack.layer.masksToBounds = true
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return stack
    }()
    
    private func layout() {
        view.backgroundColor = .systemBackground
        view.addSubview(avatarStack)
        view.addSubview(contentStack)
        
        avatarStack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        contentStack.snp.makeConstraints { make in
            make.top.equalTo(avatarStack.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
}
