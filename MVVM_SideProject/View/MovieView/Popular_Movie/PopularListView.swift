//
//  PopularListView.swift
//  MVVM_SideProject
//
//  Created by Willy Hsu on 2025/4/20.
//

import Foundation
import UIKit
import SnapKit

class PopularListView: UIView {
    
    let collectionView: UICollectionView
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        let text = "熱門電影"
        let attrs: [NSAttributedString.Key: Any] = [
            .font: ThemeFont.bold(ofSize: 20),
            .foregroundColor: UIColor.label
        ]
        let attributed = NSMutableAttributedString(string: text, attributes: attrs)
        let attachment = NSTextAttachment()
        let image = UIImage(systemName: "chevron.right")?.withTintColor(.label)
        attachment.image = image
        attributed.append(NSAttributedString(attachment: attachment))
        label.attributedText = attributed
        label.numberOfLines = 1
        label.font = ThemeFont.bold(ofSize: 20)
        label.textColor = .label
        return label
    }()
    
    private static func makeCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.sectionInset = .zero
        layout.itemSize = CGSize(width: 140, height: 210)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }
    
    override init(frame: CGRect) {
        collectionView = PopularListView.makeCollectionView()
        super.init(frame: frame)
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.register(PopularMovieCell.self,
                                forCellWithReuseIdentifier: "PopularMovieCell")
        setupViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().inset(20)
        }
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(180)
        }
    }
}


extension PopularListView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "PopularMovieCell",
            for: indexPath) as! PopularMovieCell
        cell.imageView.image = UIImage(systemName: "film")
        cell.imageView.tintColor = .label
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 240, height: 180)
    }
}
