//
//  PopularListView.swift
//  MVVM_SideProject
//
//  Created by Willy Hsu on 2025/4/20.
//

import Foundation
import UIKit
import SnapKit
import Combine
import SDWebImage

class PopularListView: UIView {
    
    let collectionView: UICollectionView
    private var movies:[Movie] = []{
        didSet{collectionView.reloadData()}
    }
    private let httpClient = MovieHTTPClient()
    private var cancellables = Set<AnyCancellable>()
    var onMovieSelected: ((Movie) -> Void)?
    
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
        layout.itemSize = CGSize(width: 200, height: 300)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }
    
    private func fetchPopularMovies() {
        httpClient.fetchPopularMovies()
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] list in
                self?.movies = list
            }
            .store(in: &cancellables)
    }
    
    override init(frame: CGRect) {
        collectionView = PopularListView.makeCollectionView()
        super.init(frame: frame)
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.register(PopularMovieCell.self,
                                forCellWithReuseIdentifier: "PopularMovieCell")
        setupViews()
        fetchPopularMovies()
        
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
        collectionView.decelerationRate = .fast
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(300)
        }
    }
}


extension PopularListView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "PopularMovieCell",
            for: indexPath) as! PopularMovieCell
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        if let callback = onMovieSelected {
            callback(movie)
        }
    }
}

extension PopularListView:UIScrollViewDelegate{
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let cellWidth = layout.itemSize.width + layout.minimumLineSpacing
        let proposedX = targetContentOffset.pointee.x + scrollView.contentInset.left
        let index = round(proposedX / cellWidth)
        let newX = index * cellWidth - scrollView.contentInset.left
        targetContentOffset.pointee.x = newX
    }
}
