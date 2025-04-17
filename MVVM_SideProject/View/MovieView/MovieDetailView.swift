//  MovieDetailView.swift
//  MVVM_SideProject
//
//  Created by Willy Hsu on 2025/4/16.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage

class MovieDetailView:UIViewController{
    private let movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.font = ThemeFont.bold(ofSize: 30)
        return label
    }()
    
    private let overviewTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "劇情簡介"
        label.font = ThemeFont.bold(ofSize: 18)
        label.textColor = .label
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = ThemeFont.regular(ofSize: 16)
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.font = ThemeFont.regular(ofSize: 16)
        return label
    }()
    
    private let posterImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = 8
        img.layer.masksToBounds = true
        img.image = UIImage(systemName: "photo.stack.fill")
        return img
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        let ratingString = NSMutableAttributedString()
        ratingString.append(NSAttributedString(
            string: "評分\n",
            attributes: [
                .font: ThemeFont.bold(ofSize: 14)
            ]
        ))
        ratingString.append(NSAttributedString(
            string: String(format: "%.1f", movie.voteAverage),
            attributes: [
                .font: ThemeFont.bold(ofSize: 18),
                .foregroundColor: UIColor.label
            ]
        ))
        
        label.attributedText = ratingString
        return label
    }()
    
    private lazy var popularityLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        let popString = NSMutableAttributedString()
        popString.append(NSAttributedString(string: "人氣\n", attributes: [
            .font: ThemeFont.bold(ofSize: 14)
        ]))
        popString.append(NSAttributedString(string: String(format: "%.1f", movie.popularity), attributes: [
            .font: ThemeFont.bold(ofSize: 18),
            .foregroundColor: UIColor.label
        ]))
        label.attributedText = popString
        
        return label
    }()
    
    private func configure() {
        let overviewText = movie.overview.isEmpty ? "暫無劇情簡介" : movie.overview
        overviewLabel.text = overviewText
        
        if let posterPath = movie.posterPath,
           let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
            posterImageView.sd_setImage(
                with: url,
                placeholderImage: UIImage(systemName: "photo.badge.arrow.down.fill"),
                options: [.retryFailed, .highPriority]
            )
        }
        
        let year = movie.releaseDate.components(separatedBy: "-").first ?? movie.releaseDate
        
        titleLabel.text = movie.originalTitle
        releaseDateLabel.text = year
        
        
    }
    
    private lazy var ratingPopularityStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            ratingLabel,
            popularityLabel
        ])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var infoStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [posterImageView,overviewLabel])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .top
    stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private func setupLayout() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        view.addSubview(releaseDateLabel)
        releaseDateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        view.addSubview(ratingPopularityStack)
        ratingPopularityStack.snp.makeConstraints { make in
            make.top.equalTo(releaseDateLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        let ratingUnderline = UIView()
        ratingUnderline.backgroundColor = .separator
        view.addSubview(ratingUnderline)
        ratingUnderline.snp.makeConstraints { make in
            make.top.equalTo(ratingPopularityStack.snp.bottom).offset(10)
            make.height.equalTo(1)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        view.addSubview(overviewTitleLabel)
        overviewTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(ratingUnderline.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        view.addSubview(infoStack)
        infoStack.snp.makeConstraints { make in
            make.top.equalTo(overviewTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        posterImageView.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(posterImageView.snp.width).multipliedBy(3.0/2.0)
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.height.equalTo(posterImageView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        configure()
    }
    
}
