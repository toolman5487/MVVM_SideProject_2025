//
//  MovieDetailViewModel.swift
//  MVVM_SideProject
//
//  Created by Willy Hsu on 2025/4/18.
//

import Foundation
import Combine

class MovieDetailViewModel {
    
    private let movieId: Int
    
    @Published private(set) var movieDetail: MovieDetailModel?
    @Published private(set) var loadingCompleted: Bool = false
    private let httpClient:MovieHTTPClient
    private var cancellables = Set<AnyCancellable>()
    
    func fetchDetail() {
        
        httpClient.fetchMovieDetail(id: movieId)
            .sink{ [weak self]completion in
                switch completion {
                case .finished:
                    self?.loadingCompleted = true
                case .failure(let error):
                    print("Error:\(error)")
                }
            } receiveValue: {[weak self] model in
                self?.movieDetail = model
            }.store(in: &cancellables)
    }
    
    init(movieId: Int,httpClient: MovieHTTPClient = MovieHTTPClient()) {
        self.movieId = movieId
        self.httpClient = httpClient
    }
}
