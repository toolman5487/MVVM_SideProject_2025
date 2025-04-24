//
//  MovieReviewViewModel.swift
//  MVVM_SideProject
//
//  Created by Willy Hsu on 2025/4/24.
//

import Foundation
import Combine

class MovieReviewViewModel {
    @Published private(set) var reviews: [Review] = []
    private var cancellables = Set<AnyCancellable>()
    private let httpClient = MovieHTTPClient()
    private let movieId: Int

    init(movieId: Int) {
        self.movieId = movieId
    }

    func fetchReviews() {
        httpClient.fetchMovieReviews(id: movieId)
            .replaceError(with: [])
            .sink { [weak self] list in
                self?.reviews = list
            }
            .store(in: &cancellables)
    }
}
