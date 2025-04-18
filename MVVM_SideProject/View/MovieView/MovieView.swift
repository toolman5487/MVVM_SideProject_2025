//  MovieView.swift
//  MVVM_SideProject
//
//  Created by Willy Hsu on 2025/4/16.
//

import Foundation
import UIKit
import SnapKit
import Combine
import SDWebImage

class MovieView: UIViewController {
    
    private let upcomingMoviesView = UpcomingMoviesCollectionView()
    
    private let movieListViewModel: MovieListViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var searchController: UISearchController = {
        let resultsVC = SearchResultsView(viewModel: movieListViewModel)
        let searchController = UISearchController(searchResultsController: resultsVC)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = resultsVC
        return searchController
    }()
    
    init(movieListViewModel: MovieListViewModel) {
        self.movieListViewModel = movieListViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        view.addSubview(upcomingMoviesView)
        
        upcomingMoviesView.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(250)
            }
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "電影"
    }
    
    private func bind() {
        movieListViewModel.$loadingCompleted
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if completion {
                    let urls = self?.movieListViewModel.movies.compactMap { movie in
                        movie.posterPath.flatMap { URL(string: "https://image.tmdb.org/t/p/w200\($0)") }
                    } ?? []
                    SDWebImagePrefetcher.shared.prefetchURLs(urls)
                }
            }.store(in: &cancellables)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        layout()
    }
}
