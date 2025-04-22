//
//  UpcomingMoviesCollectionView.swift
//  MVVM_SideProject
//
//  Created by Willy Hsu on 2025/4/18.
//

import Foundation
import UIKit
import SnapKit
import Combine
import SDWebImage

class UpcomingMoviesCollectionView: UIView {
    
    let collectionView: UICollectionView
    
    private var movies: [Movie] = [] {
        didSet { collectionView.reloadData() }
    }
    private var cancellables = Set<AnyCancellable>()
    private let httpClient = MovieHTTPClient()
    var onMovieSelected: ((Movie) -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        let text = "準備上映"
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
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.itemSize = CGSize(width: 200, height: 300)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }
    
    
    private func fetchUpcomingMovies() {
        httpClient.fetchUpcomingMovies()
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] list in
                self?.movies = list
            }
            .store(in: &cancellables)
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().inset(20)
        }
        
        addSubview(collectionView)
        collectionView.decelerationRate = .fast
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(300)
        }
    }
    
    override init(frame: CGRect) {
        collectionView = UpcomingMoviesCollectionView.makeCollectionView()
        super.init(frame: frame)
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.register(UpcomingMovieCell.self,
                                forCellWithReuseIdentifier: "UpcomingMovieCell")
        setupViews()
        fetchUpcomingMovies()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension UpcomingMoviesCollectionView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "UpcomingMovieCell",
            for: indexPath) as! UpcomingMovieCell
        let movie = movies[indexPath.item]
        
        if let path = movie.posterPath,
           let url = URL(string: "https://image.tmdb.org/t/p/w342\(path)") {
            cell.imageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "film"))
        } else {
            cell.imageView.image = UIImage(systemName: "film")
        }
        cell.imageView.tintColor = .label
        cell.titleLabel.text = movie.title
        return cell
    }
    
}
