//
//  TipCalculatorView.swift
//  MVVM_SideProject
//
//  Created by Willy Hsu on 2025/4/16.
//

import Foundation
import UIKit

class TipCalculatorView:UIViewController{
    
    // 建立 scrollView 和內容容器
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = .lightGray
        return sv
    }()
    
    // 這個 contentView 放置所有需要捲動展示的內容
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    // 為了示範添加一些內容，我們在 contentView 中添加兩個 Label
    private let topLabel: UILabel = {
        let label = UILabel()
        label.text = "這是 Scroll View 的上部內容"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private let bottomLabel: UILabel = {
        let label = UILabel()
        label.text = "這是 Scroll View 的下部內容\n（滑動以查看更多內容）"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private func setupUI() {
        // 1. 把 scrollView 加入到主視圖中
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            // 使用安全區，讓 scrollView 充滿整個畫面（或你需要的區域）
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        // 2. 把 contentView 加入到 scrollView 中
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            // 利用 scrollView 的 contentLayoutGuide 設定約束，這樣系統能自動計算 contentSize
            make.edges.equalTo(scrollView.contentLayoutGuide)
            // 設定內容寬度等於 scrollView 的 frameLayoutGuide 寬度，避免橫向捲動
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        // 3. 把 topLabel 和 bottomLabel 加入到 contentView 中
        contentView.addSubview(topLabel)
        contentView.addSubview(bottomLabel)
        
        // 4. 設定 topLabel 的約束：放在 contentView 的上部
        topLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        // 5. 設定 bottomLabel 的約束，確保其底部和 contentView 的底部有約束
        bottomLabel.snp.makeConstraints { make in
            // 將 bottomLabel 放在 topLabel 下方，並留出足夠的空間產生捲動效果
            make.top.equalTo(topLabel.snp.bottom).offset(500)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            // 關鍵在這裡：將 bottomLabel 的底部約束到 contentView 的底部，
            // 讓 Auto Layout 可以自動計算 contentView 的高度
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "服務費計算器"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
    }
}
