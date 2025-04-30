//
//  MovieIntroductionView.swift
//  MVVM_SideProject
//
//  Created by Willy Hsu on 2025/4/18.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage
import Combine

class MovieDetailView:UIViewController{
    
    private let movieReviewView = MovieReviewCollectionView()
    
    private let viewModel:MovieDetailViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.contentInset.bottom = 40
        return scrollView
    }()
    
    // MARK: backdropImage
    private let backdropImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        imageview.clipsToBounds = true
        imageview.image = UIImage(named: "tmdb")
        return imageview
    }()
    // MARK: - titleStack -
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.bold(ofSize: 32)
        label.numberOfLines = 1
        label.text = "Movie Title"
        return label
    }()
    private let releaseRuntimeLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.regular(ofSize: 16)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.text = "2025"
        return label
    }()
    lazy var titleStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, releaseRuntimeLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .leading
        return stack
    }()
    // MARK: - voteStack -
    private lazy var popularityLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        let boldAttrs: [NSAttributedString.Key: Any] = [
            .font: ThemeFont.bold(ofSize: 20),
            .foregroundColor: UIColor.secondaryLabel
        ]
        let regularAttrs: [NSAttributedString.Key: Any] = [
            .font: ThemeFont.regular(ofSize: 16),
            .foregroundColor: UIColor.label
        ]
        let stats = NSMutableAttributedString()
        stats.append(NSAttributedString(string: "人氣\n", attributes: boldAttrs))
        stats.append(NSAttributedString(string: "0.0", attributes: regularAttrs))
        label.attributedText = stats
        return label
    }()
    private lazy var voteAverageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        let boldAttrs: [NSAttributedString.Key: Any] = [
            .font: ThemeFont.bold(ofSize: 20),
            .foregroundColor: UIColor.secondaryLabel
        ]
        let regularAttrs: [NSAttributedString.Key: Any] = [
            .font: ThemeFont.regular(ofSize: 16),
            .foregroundColor: UIColor.label
        ]
        let stats = NSMutableAttributedString()
        stats.append(NSAttributedString(string: "評分\n", attributes: boldAttrs))
        stats.append(NSAttributedString(string: "0.0", attributes: regularAttrs))
        label.attributedText = stats
        return label
    }()
    private lazy var voteCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        let boldAttrs: [NSAttributedString.Key: Any] = [
            .font: ThemeFont.bold(ofSize: 20),
            .foregroundColor: UIColor.secondaryLabel
        ]
        let regularAttrs: [NSAttributedString.Key: Any] = [
            .font: ThemeFont.regular(ofSize: 16),
            .foregroundColor: UIColor.label
        ]
        let stats = NSMutableAttributedString()
        stats.append(NSAttributedString(string: "投票數\n", attributes: boldAttrs))
        stats.append(NSAttributedString(string: "0", attributes: regularAttrs))
        label.attributedText = stats
        return label
    }()
    private lazy var voteStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [popularityLabel,voteAverageLabel,voteCountLabel])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.backgroundColor = .secondarySystemBackground
        stack.layer.cornerRadius = 10
        stack.layer.masksToBounds = true
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return stack
    }()
    // MARK: - overviewStack -
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(systemName: "film.stack.fill")
        imageView.tintColor = .white
        return imageView
    }()
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.regular(ofSize: 16)
        label.textColor = .label
        label.numberOfLines = 16
        label.text = "電影簡介"
        return label
    }()
    private lazy var overviewStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [posterImageView,overviewLabel])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .top
        stack.distribution = .fillEqually
        stack.backgroundColor = .secondarySystemBackground
        stack.layer.cornerRadius = 10
        stack.layer.masksToBounds = true
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)
        return stack
    }()
    // MARK: - productionStack -
    private let budgetRevenueLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.regular(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        let boldAttrs: [NSAttributedString.Key: Any] = [
            .font: ThemeFont.bold(ofSize: 20),
            .foregroundColor: UIColor.secondaryLabel
        ]
        let regularAttrs: [NSAttributedString.Key: Any] = [
            .font: ThemeFont.regular(ofSize: 16),
            .foregroundColor: UIColor.label
        ]
        let stats = NSMutableAttributedString()
        stats.append(NSAttributedString(string: "票房\n", attributes: boldAttrs))
        stats.append(NSAttributedString(string: "$0", attributes: regularAttrs))
        label.attributedText = stats
        return label
    }()
    private let productionLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.regular(ofSize: 14)
        label.textColor = .label
        label.numberOfLines = 2
        let boldAttrs: [NSAttributedString.Key: Any] = [
            .font: ThemeFont.bold(ofSize: 20),
            .foregroundColor: UIColor.secondaryLabel
        ]
        let regularAttrs: [NSAttributedString.Key: Any] = [
            .font: ThemeFont.regular(ofSize: 16),
            .foregroundColor: UIColor.label
        ]
        let stats = NSMutableAttributedString()
        stats.append(NSAttributedString(string: "電影公司\n", attributes: boldAttrs))
        stats.append(NSAttributedString(string: "TMDB", attributes: regularAttrs))
        label.attributedText = stats
        return label
        
    }()
    
    private lazy var productionStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [budgetRevenueLabel,productionLabel])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.backgroundColor = .secondarySystemBackground
        stack.layer.cornerRadius = 10
        stack.layer.masksToBounds = true
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return stack
    }()
    
    private let reviewLabel: UILabel = {
        let label = UILabel()
        label.text = "觀眾短評"
        label.font = ThemeFont.demiBold(ofSize: 20)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private func bindViewModel() {
        viewModel.$movieDetail
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] detail in
                self?.configure(with: detail)
            }
            .store(in: &cancellables)
    }
    
    private func configure(with detail: MovieDetailModel) {
        titleLabel.text = detail.title
        let year = String(detail.releaseDate.prefix(4))
        releaseRuntimeLabel.text = "\(year) | \(detail.runtime) 分鐘"
        
        if let path = detail.backdropPath,
           let url = URL(string: "https://image.tmdb.org/t/p/w780\(path)") {
            backdropImageView.sd_setImage(with: url)
        }
        
        if let poster = detail.posterPath,
           let url = URL(string: "https://image.tmdb.org/t/p/w342\(poster)") {
            posterImageView.sd_setImage(with: url)
        }
        overviewLabel.text = detail.overview
        
        func makeStats(title: String, value: String) -> NSAttributedString {
            let bold = [NSAttributedString.Key.font: ThemeFont.bold(ofSize: 20),
                        .foregroundColor: UIColor.secondaryLabel]
            let regular = [NSAttributedString.Key.font: ThemeFont.regular(ofSize: 16),
                           .foregroundColor: UIColor.label]
            let stats = NSMutableAttributedString(string: "\(title)\n", attributes: bold)
            stats.append(NSAttributedString(string: value, attributes: regular))
            return stats
        }
        popularityLabel.attributedText = makeStats(title: "人氣", value: String(format: "%.1f", detail.popularity))
        let scoreText = String(format: "%.1f / 10", detail.voteAverage)
        voteAverageLabel.attributedText = makeStats(title: "評分", value: scoreText)
        voteCountLabel.attributedText   = makeStats(title: "投票數", value: "\(detail.voteCount)")
        let revenueNumber = detail.revenue
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let revenueString = numberFormatter.string(from: NSNumber(value: revenueNumber)) ?? "\(revenueNumber)"
        let revenueValueText = "$ \(revenueString) USD"
        budgetRevenueLabel.attributedText = makeStats(title: "票房", value: revenueValueText)
        let comps = detail.productionCompanies.map(\.name).joined(separator: ", ")
        productionLabel.attributedText = makeStats(title: "電影公司", value: comps)
        
        movieReviewView.configure(with: detail.id)
    }
    
    // MARK: - layout -
    private lazy var wholeStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [backdropImageView,titleStack,voteStack,overviewStack,productionStack,reviewLabel,movieReviewView])
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    private func layoutUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(wholeStack)
        
        wholeStack.snp.makeConstraints { make in
            make.top.equalTo(scrollView.contentLayoutGuide.snp.top)
            make.leading.trailing.equalTo(scrollView.contentLayoutGuide)
            make.bottom.equalTo(scrollView.contentLayoutGuide.snp.bottom)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        backdropImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(300)
        }
        
        titleStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.top.equalTo(backdropImageView.snp.bottom).offset(16)
        }
        
        voteStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleStack.snp.bottom).offset(32)
            
            overviewStack.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(16)
                make.top.equalTo(voteStack.snp.bottom).offset(32)
            }
            posterImageView.snp.makeConstraints { make in
                make.height.equalTo(300)
                make.width.equalTo(200)
            }
        }
        
        productionStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(overviewStack.snp.bottom).offset(32)
        }
        
        reviewLabel.snp.makeConstraints { make in
            make.top.equalTo(productionStack.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        movieReviewView.snp.makeConstraints { make in
            make.top.equalTo(reviewLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(20)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        viewModel.fetchDetail()
        bindViewModel()
    }
}
