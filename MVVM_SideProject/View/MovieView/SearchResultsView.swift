//
//  SearchResultsViewController.swift
//  MVVM_SideProject
//
//  Created by Willy Hsu on 2025/4/18.
//

import Foundation
import UIKit
import SnapKit
import Combine
import SDWebImage

class SearchResultsView: UIViewController, UISearchResultsUpdating {
    
    var onMovieSelected: ((Movie) -> Void)?
    private let movieListviewModel: MovieListViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SearchResultCell")
        return tableView
    }()
    
    private func bindViewModel() {
        movieListviewModel.$movies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        movieListviewModel.setSearchText(query)
    }
    
    init(viewModel: MovieListViewModel) {
        self.movieListviewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.dataSource = self
        tableView.delegate   = self
        
        bindViewModel()
    }
}

extension SearchResultsView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieListviewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "SearchResultCell", for: indexPath)
        let movie = movieListviewModel.movies[indexPath.row]
        var config = cell.defaultContentConfiguration()
        config.text = movie.originalTitle
        config.textProperties.font = ThemeFont.bold(ofSize: 16)
        config.secondaryText = movie.releaseDate
        cell.contentConfiguration = config
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movieListviewModel.movies[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        onMovieSelected?(movie)
    }
}


