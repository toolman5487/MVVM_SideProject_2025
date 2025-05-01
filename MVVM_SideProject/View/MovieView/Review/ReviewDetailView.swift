//
//  ReviewDetailView.swift
//  MVVM_SideProject
//
//  Created by Willy Hsu on 2025/5/1.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage

class ReviewDetailViewController: UIViewController {
    
    private let review: Review
    
    init(review: Review) {
        self.review = review
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.bold(ofSize: 20)
        label.textColor = .label
        return label
    }()
    
    private let avatarImage: UIImageView = {
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
        let stack = UIStackView(arrangedSubviews: [avatarImage, authorLabel])
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
        avatarImage.snp.makeConstraints { make in
            make.height.width.equalTo(40)
        }
        
        contentStack.snp.makeConstraints { make in
            make.top.equalTo(avatarStack.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
        }
    }
    
    func configure(){
        authorLabel.text = review.author.isEmpty ? "Anonymous" : review.author
        contentLabel.text = review.content
        ratingLabel.text = "Rating: \(review.authorDetails.rating ?? 0)"
        if let date = ISO8601DateFormatter().date(from: review.createdAt) {
            createdAtLabel.text = DateFormatter.localizedString(
                from: date,
                dateStyle: .medium,
                timeStyle: .short
            )
        } else {
            createdAtLabel.text = review.createdAt
        }
        if let avatarPath = review.authorDetails.avatarPath,
           let url = URL(string: "https://image.tmdb.org/t/p/w200\(avatarPath)") {
            avatarImage.sd_setImage(with: url)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        configure()
    }
}
