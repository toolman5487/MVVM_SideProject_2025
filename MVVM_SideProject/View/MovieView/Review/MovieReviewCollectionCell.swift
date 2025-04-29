//
//  MovieReviewCollectionCell.swift
//  MVVM_SideProject
//
//  Created by Willy Hsu on 2025/4/24.
//

import UIKit
import SnapKit

class MovieReviewCollectionCell: UICollectionViewCell {
    
    let authorLabel:UILabel = {
        let label = UILabel()
        label.text = "Author"
        label.textColor = .label
        label.font = ThemeFont.demiBold(ofSize: 16)
        return label
    }()
    
    let contentLabel:UILabel = {
        let label = UILabel()
        label.text = "Review Content"
        label.textColor = .label
        label.font = ThemeFont.regular(ofSize: 12)
        label.numberOfLines = 10
        return label
    }()
    
    private func layout(){
        contentView.addSubview(authorLabel)
        contentView.addSubview(contentLabel)

        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
        }

        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.lessThanOrEqualToSuperview().inset(8)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        authorLabel.text = nil
        contentLabel.text = nil
    }
}
