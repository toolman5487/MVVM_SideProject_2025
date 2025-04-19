//
//  UpcomingMovieCell.swift
//  MVVM_SideProject
//
//  Created by Willy Hsu on 2025/4/19.
//

import UIKit
import SnapKit

class UpcomingMovieCell: UICollectionViewCell {
    
      let imageView: UIImageView = {
          let imageView = UIImageView()
          imageView.contentMode = .scaleAspectFill
          imageView.clipsToBounds = true
          return imageView
      }()

      override init(frame: CGRect) {
          super.init(frame: frame)
          contentView.addSubview(imageView)
          imageView.snp.makeConstraints { make in
              make.edges.equalToSuperview()
          }
      }

      required init?(coder: NSCoder) {
          super.init(coder: coder)
          contentView.addSubview(imageView)
          imageView.snp.makeConstraints { make in
              make.edges.equalToSuperview()
          }
      }

      override func prepareForReuse() {
          super.prepareForReuse()
          imageView.image = nil
      }
  }
