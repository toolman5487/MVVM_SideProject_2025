//
//  NowPlayingMovieCell.swift
//  MVVM_SideProject
//
//  Created by Willy Hsu on 2025/4/20.
//

import UIKit
import SnapKit

class NowPlayingMovieCell: UICollectionViewCell {
    
      let imageView: UIImageView = {
          let imageView = UIImageView()
          imageView.contentMode = .scaleAspectFill
          imageView.clipsToBounds = true
          imageView.layer.cornerRadius = 20
          imageView.layer.masksToBounds = true
          return imageView
      }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.demiBold(ofSize: 16)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
      override init(frame: CGRect) {
          super.init(frame: frame)
          contentView.addSubview(imageView)
          contentView.addSubview(titleLabel)
          imageView.snp.makeConstraints { make in
              make.top.leading.trailing.equalToSuperview()
              make.bottom.equalTo(titleLabel.snp.top).offset(-4)
          }
          titleLabel.snp.makeConstraints { make in
              make.leading.trailing.equalToSuperview().inset(4)
              make.bottom.equalToSuperview().inset(4)
              make.height.equalTo(20)
          }
      }

      required init?(coder: NSCoder) {
          super.init(coder: coder)
          contentView.addSubview(imageView)
          contentView.addSubview(titleLabel)
          imageView.snp.makeConstraints { make in
              make.top.leading.trailing.equalToSuperview()
              make.bottom.equalTo(titleLabel.snp.top).offset(-4)
          }
          titleLabel.snp.makeConstraints { make in
              make.leading.trailing.equalToSuperview().inset(4)
              make.bottom.equalToSuperview().inset(4)
              make.height.equalTo(20)
          }
      }

      override func prepareForReuse() {
          super.prepareForReuse()
          imageView.image = nil
          titleLabel.text = nil
      }
  }

