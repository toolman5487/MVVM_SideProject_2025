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
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var headerStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [avatarImage, authorLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        stack.backgroundColor = .secondarySystemBackground
        stack.layer.cornerRadius = 10
        stack.layer.masksToBounds = true
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return stack
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    private func layout() {
        view.backgroundColor = .systemBackground
        view.addSubview(headerStack)
        headerStack.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(96)
        }
        avatarImage.snp.makeConstraints { make in
            make.height.width.equalTo(44)
        }
        avatarImage.layer.cornerRadius = 22
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(headerStack.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).inset(16)
        }

        containerView.addSubview(ratingLabel)
        ratingLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(8)
        }
        
        containerView.addSubview(createdAtLabel)
        createdAtLabel.snp.makeConstraints { make in
            make.top.equalTo(ratingLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
        }
        containerView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(createdAtLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
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
            avatarImage.sd_setImage(with: url, placeholderImage: UIImage(systemName: "person.circle.fill"))
        } else {
            avatarImage.image = UIImage(systemName: "person.circle.fill")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        configure()
    }
}
