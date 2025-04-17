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

class MovieView:UIViewController{
    
    private let movieListViewModel: MovieListViewModel
    private var cancellables:Set<AnyCancellable> = []
    
    init(movieListViewModel: MovieListViewModel) {
        self.movieListViewModel = movieListViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var searchbar : UISearchBar = {
        let searchbar = UISearchBar()
        searchbar.delegate = self
        searchbar.translatesAutoresizingMaskIntoConstraints = false
        searchbar.searchBarStyle = .minimal
        searchbar.placeholder = "搜尋電影"
        return searchbar
    }()
    
    lazy var movieTableView : UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var searchbarStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [searchbar, movieTableView])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    func layout(){
        view.addSubview(searchbarStackView)
        searchbarStackView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "電影"
    }
    
    private func bind(){
        movieListViewModel.$loadingCompleted
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if completion {
                    self?.movieTableView.reloadData()
                    // Prefetch poster images
                    let urls = self?.movieListViewModel.movies.compactMap { movie in
                        movie.posterPath.flatMap { URL(string: "https://image.tmdb.org/t/p/w500\($0)") }
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
        layout()
        movieTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MovieTableViewcell")
        bind()
        movieTableView.keyboardDismissMode = .onDrag
        movieTableView.prefetchDataSource = self
    }
}

extension MovieView:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieListViewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewcell", for: indexPath)
        let movie = movieListViewModel.movies[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = movie.originalTitle
        content.textProperties.font = ThemeFont.demiBold(ofSize: 20)
        content.secondaryText = movie.releaseDate
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped row: \(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = movieListViewModel.movies[indexPath.row]
        let detailVC = MovieDetailView(movie: movie)
        detailVC.modalPresentationStyle = .pageSheet
        if let sheet = detailVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 16
        }
        present(detailVC, animated: true, completion: nil)
    }
    
}

extension MovieView: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        movieListViewModel.setSearchText(searchText)
    }
}

extension MovieView: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let urls = indexPaths.compactMap { idx in
            let movie = movieListViewModel.movies[idx.row]
            return movie.posterPath.flatMap { URL(string: "https://image.tmdb.org/t/p/w500\($0)") }
        }
        SDWebImagePrefetcher.shared.prefetchURLs(urls)
    }
}
