//
//  MovieReviewCollectionView.swift
//  MVVM_SideProject
//
//  Created by Willy Hsu on 2025/4/24.
//

import UIKit
import SnapKit
import Combine
import SDWebImage

class MovieReviewCollectionView: UIView {
    
    private var reviews: [Review] = [] {
        didSet { collectionView.reloadData() }
    }
    private var cancellables = Set<AnyCancellable>()
    private let httpClient = MovieHTTPClient()
    private var movieId: Int!
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "觀眾短評"
        label.font = ThemeFont.demiBold(ofSize: 16)
        label.textColor = .label
        
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.itemSize = CGSize(width: 200, height: 120)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    
    func configure(with movieId: Int) {
        self.movieId = movieId
        fetchReviews()
    }
    
    private func fetchReviews() {
        httpClient.fetchMovieReviews(id: movieId)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] list in
                self?.reviews = list
            }
            .store(in: &cancellables)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(collectionView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(120)
            make.bottom.equalToSuperview().inset(16)
        }
        
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.register(MovieReviewCollectionCell.self, forCellWithReuseIdentifier: "MovieReviewCollectionCell")
    }
}

extension MovieReviewCollectionView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieReviewCollectionCell",
                                          for: indexPath) as! MovieReviewCollectionCell
        let review = reviews[indexPath.item]
        cell.configure(with: review)
        return cell
    }

}
