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
    
    let collectionView: UICollectionView
    
    private static func makeCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.sectionInset = .zero
        layout.itemSize = CGSize(width: 200, height: 200)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }
    
    lazy var reviewStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [collectionView])
        stack.axis = .vertical
        stack.spacing = 8
        stack.backgroundColor = .secondarySystemBackground
        stack.distribution = .fillProportionally
        stack.layer.cornerRadius = 10
        stack.layer.masksToBounds = true
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
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
    
    private func setupViews() {
        addSubview(reviewStackView)
        reviewStackView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(200)
        }
        
    }
    
    override init(frame: CGRect) {
        collectionView = MovieReviewCollectionView.makeCollectionView()
        super.init(frame: frame)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieReviewCollectionCell.self, forCellWithReuseIdentifier: "MovieReviewCollectionCell")
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
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
        cell.authorLabel.text = review.author.isEmpty ? "Anonymous" : review.author
        cell.contentLabel.text = review.content
        
        return cell
    }

}
