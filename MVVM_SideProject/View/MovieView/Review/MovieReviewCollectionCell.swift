//
//  MovieReviewCollectionCell.swift
//  MVVM_SideProject
//
//  Created by Willy Hsu on 2025/4/24.
//

import UIKit
import SnapKit

class MovieReviewCollectionCell: UICollectionViewCell {
    
    private let authorLabel = UILabel()
    private let contentLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(authorLabel)
        contentView.addSubview(contentLabel)
        
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        authorLabel.font = ThemeFont.demiBold(ofSize: 16)
        contentLabel.font = ThemeFont.regular(ofSize: 12)
        contentLabel.numberOfLines = 3

        
        authorLabel.snp.makeConstraints {
            make in make.top.leading.trailing.equalToSuperview().inset(8)
        }
        contentLabel.snp.makeConstraints {
            make in
            make.top.equalTo(authorLabel.snp.bottom).offset(4)
            make.leading.trailing.bottom.equalToSuperview().inset(8)
        }
    }
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(with review: Review) {
        authorLabel.text  = review.author
        contentLabel.text = review.content
    }
}
