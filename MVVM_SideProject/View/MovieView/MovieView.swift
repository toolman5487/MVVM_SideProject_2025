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
    
    private let scrollView = UIScrollView()
    
    private let upcomingMoviesView = UpcomingMoviesCollectionView()
    private let nowPlayingListView = NowPlayingListView()
    private let popularListView = PopularListView()
    private let topRateListView = TopRateListView()
    
    private let movieListViewModel: MovieListViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var searchController: UISearchController = {
        let resultsVC = SearchResultsView(viewModel: movieListViewModel)
        resultsVC.onMovieSelected = { [weak self] movie in
            guard let self = self else { return }
            let detailVM = MovieDetailViewModel(movieId: movie.id)
            let detailVC = MovieDetailView(viewModel: detailVM)
            detailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
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
    
    private func layout() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(upcomingMoviesView)
        upcomingMoviesView.snp.remakeConstraints { make in
            make.top.equalTo(scrollView.contentLayoutGuide.snp.top).offset(16)
            make.leading.trailing.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.equalTo(300)
        }
        
        scrollView.addSubview(nowPlayingListView)
        nowPlayingListView.snp.makeConstraints { make in
            make.top.equalTo(upcomingMoviesView.snp.bottom).offset(60)
            make.leading.trailing.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.equalTo(300)
        }
        
        scrollView.addSubview(popularListView)
        popularListView.snp.makeConstraints { make in
            make.top.equalTo(nowPlayingListView.snp.bottom).offset(60)
            make.leading.trailing.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.equalTo(300)
        }
        
        scrollView.addSubview(topRateListView)
        topRateListView.snp.makeConstraints { make in
            make.top.equalTo(popularListView.snp.bottom).offset(60)
            make.leading.trailing.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.equalTo(300)
            make.bottom.equalTo(scrollView.contentLayoutGuide.snp.bottom).offset(-40)
        }
    }
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "電影"
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
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
    
    private func configureSelection() {
        nowPlayingListView.onMovieSelected = { [weak self] movie in
            guard let self = self else { return }
            let detailVM = MovieDetailViewModel(movieId: movie.id)
            let detailVC = MovieDetailView(viewModel: detailVM)
            detailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        
        upcomingMoviesView.onMovieSelected = { [weak self] movie in
            guard let self = self else { return }
            let detailVM = MovieDetailViewModel(movieId: movie.id)
            let detailVC = MovieDetailView(viewModel: detailVM)
            detailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        
        popularListView.onMovieSelected = { [weak self] movie in
            guard let self = self else { return }
            let detailVM = MovieDetailViewModel(movieId: movie.id)
            let detailVC = MovieDetailView(viewModel: detailVM)
            detailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        
        topRateListView.onMovieSelected = { [weak self] movie in
            guard let self = self else { return }
            let detailVM = MovieDetailViewModel(movieId: movie.id)
            let detailVC = MovieDetailView(viewModel: detailVM)
            detailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        layout()
        configureSelection()
    }
}
