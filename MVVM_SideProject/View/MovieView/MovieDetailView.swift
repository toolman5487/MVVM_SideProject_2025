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
        imageview.image = UIImage(named: "tmdb")
        return imageview
    }()
// MARK: - titleStack -
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.bold(ofSize: 30)
        label.numberOfLines = 1
        label.text = "Movie Title"
        return label
    }()
    private let releaseRuntimeLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.regular(ofSize: 20)
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
        label.numberOfLines = 0
        label.text = "Overview - Overview - Overview - Overview - Overview"
        return label
    }()
    private lazy var overviewStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [posterImageView,overviewLabel])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .leading
        stack.distribution = .fillEqually
        stack.backgroundColor = .secondarySystemBackground
        stack.layer.cornerRadius = 10
        stack.layer.masksToBounds = true
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
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
        
        backdropImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        
        titleStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(backdropImageView.snp.bottom).offset(16)
        }
        
        voteStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleStack.snp.bottom).offset(32)
        }
        
        overviewStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(voteStack.snp.bottom).offset(32)
        }
        posterImageView.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.width.equalTo(300)
        }
        
        productionStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(overviewStack.snp.bottom).offset(32)
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        layoutUI()
        
    }
}
