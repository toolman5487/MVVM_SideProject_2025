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

class MovieDetailView:UIViewController{
    
    private let scrollView = UIScrollView()
    
    private let backdropImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        imageview.layer.cornerRadius = 10
        imageview.image = UIImage(named: "tmdb")
        return imageview
    }()
// MARK: - titleStack -
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.bold(ofSize: 24)
        label.textColor = .label
        label.numberOfLines = 1
        label.text = "Movie Name"
        return label
    }()
    private let releaseRuntimeLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.regular(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.text = "Movie Release Date & Runtime"
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
       label.numberOfLines = 0
       label.textAlignment = .center
       let boldAttrs: [NSAttributedString.Key: Any] = [
           .font: ThemeFont.bold(ofSize: 14),
           .foregroundColor: UIColor.secondaryLabel
       ]
       let regularAttrs: [NSAttributedString.Key: Any] = [
           .font: ThemeFont.regular(ofSize: 16),
           .foregroundColor: UIColor.label
       ]
       let stats = NSMutableAttributedString()
       stats.append(NSAttributedString(string: "人氣 ", attributes: boldAttrs))
       stats.append(NSAttributedString(string: "0.0", attributes: regularAttrs))
       label.attributedText = stats
       return label
   }()
    private lazy var voteAverageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        let boldAttrs: [NSAttributedString.Key: Any] = [
            .font: ThemeFont.bold(ofSize: 14),
            .foregroundColor: UIColor.secondaryLabel
        ]
        let regularAttrs: [NSAttributedString.Key: Any] = [
            .font: ThemeFont.regular(ofSize: 16),
            .foregroundColor: UIColor.label
        ]
        let stats = NSMutableAttributedString()
        stats.append(NSAttributedString(string: "評分 ", attributes: boldAttrs))
        stats.append(NSAttributedString(string: "0.0", attributes: regularAttrs))
        label.attributedText = stats
        return label
    }()
    private lazy var voteCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        let boldAttrs: [NSAttributedString.Key: Any] = [
            .font: ThemeFont.bold(ofSize: 14),
            .foregroundColor: UIColor.secondaryLabel
        ]
        let regularAttrs: [NSAttributedString.Key: Any] = [
            .font: ThemeFont.regular(ofSize: 16),
            .foregroundColor: UIColor.label
        ]
        let stats = NSMutableAttributedString()
        stats.append(NSAttributedString(string: "投票數 ", attributes: boldAttrs))
        stats.append(NSAttributedString(string: "0", attributes: regularAttrs))
        label.attributedText = stats
        return label
    }()
   private lazy var voteStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [popularityLabel,voteAverageLabel,voteCountLabel])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()
// MARK: - overviewStack -
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.regular(ofSize: 16)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    private lazy var overviewStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [posterImageView,overviewLabel])
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()
// MARK: - productionStack -
    private let budgetRevenueLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.regular(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.text = "票房: $0"
        return label
    }()
    private let productionLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.regular(ofSize: 14)
        label.textColor = .label
        label.numberOfLines = 1
        label.text = "製作公司"
        return label
    }()
    
    private lazy var productionStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [budgetRevenueLabel,productionLabel])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()
// MARK: - layout -
    private lazy var wholeStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [backdropImageView,titleStack,voteStack,overviewStack,productionStack])
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    private func layoutUI() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        scrollView.addSubview(wholeStack)
        wholeStack.snp.makeConstraints { make in
            make.top.equalTo(scrollView.contentLayoutGuide.snp.top)
            make.leading.trailing.equalTo(scrollView.contentLayoutGuide)
            make.bottom.equalTo(scrollView.contentLayoutGuide.snp.bottom)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        view.backgroundColor = .white
    }
}
