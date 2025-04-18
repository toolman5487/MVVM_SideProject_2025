//
//  MovieListViewModel.swift
//  MVVM_SideProject
//
//  Created by Willy Hsu on 2025/4/16.
//

import Foundation
import Combine

class MovieListViewModel {
    
    @Published var movies: [Movie] = []
    @Published var loadingCompleted: Bool = false
    private let httpClient:MovieHTTPClient
    private var cancellables = Set<AnyCancellable>()
    private var searchSubject = CurrentValueSubject<String, Never>("")
    
    init(httpClient: MovieHTTPClient) {
        self.httpClient = httpClient
        setupSearchPublisher()
    }
    
    func loadMovies(search:String) {
        httpClient.fetchSearchMovies(search: search)
            .sink { [weak self]completion in
                switch completion {
                case .finished:
                    self?.loadingCompleted = true
                case .failure(let error):
                    print("Error:\(error)")
                }
            } receiveValue: {[weak self] movies in
                self?.movies = movies
            }.store(in: &cancellables)
    }
    
    func setupSearchPublisher(){
        searchSubject
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink {[weak self] searchText in
            self?.loadMovies(search: searchText)
        }.store(in: &cancellables)
    }
    
    func setSearchText(_ text: String) {
        searchSubject.send(text)
    }
}
