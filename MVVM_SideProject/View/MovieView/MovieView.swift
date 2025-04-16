//
//  MovieView.swift
//  MVVM_SideProject
//
//  Created by Willy Hsu on 2025/4/16.
//

import Foundation
import UIKit
import SnapKit
import Combine

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
        searchbar.placeholder = "Search Movie"
        return searchbar
    }()
    
    lazy var movieTableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
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
                if completion{
                    self?.movieTableView.reloadData()
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
}

extension MovieView:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieListViewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewcell", for: indexPath)
        let movie = movieListViewModel.movies[indexPath.row]
        var contant = cell.defaultContentConfiguration()
        contant.text = movie.title
        contant.secondaryText = movie.year
        cell.contentConfiguration = contant
        return cell
    }
    
    
}

extension MovieView:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        movieListViewModel.setSearchText(searchText)
    }
}
