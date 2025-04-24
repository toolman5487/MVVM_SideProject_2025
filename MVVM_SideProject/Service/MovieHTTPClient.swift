//
//  MovieHTTPClient.swift
//  MVVM_SideProject
//
//  Created by Willy Hsu on 2025/4/16.
//

import Foundation
import Combine

enum MovieError: Error {
    case urlError
}

class MovieHTTPClient{
    
    private let apiKey = ""
    private let baseURL = "https://api.themoviedb.org/3"
    
    func fetchSearchMovies(search:String) -> AnyPublisher<[Movie], Error> {
        guard let encodedSearch = search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return Fail(error: MovieError.urlError).eraseToAnyPublisher()
        }
        let urlString = "\(baseURL)/search/movie?api_key=\(apiKey)&query=\(encodedSearch)&language=ㄒzh-TW"
        guard let movieListURL = URL(string: urlString) else {
            return Fail(error: MovieError.urlError).eraseToAnyPublisher()
        }
        return  URLSession.shared.dataTaskPublisher(for: movieListURL)
            .map(\.data)
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .map(\.results)
            .receive(on: DispatchQueue.main)
            .catch { error -> AnyPublisher<[Movie], Error> in
                return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: UpcomingMovie
    func fetchUpcomingMovies() -> AnyPublisher<[Movie], Error> {
        let urlString = "\(baseURL)/movie/upcoming?api_key=\(apiKey)&language=zh-TW"
        guard let url = URL(string: urlString) else {
            return Fail(error: MovieError.urlError).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .map(\.results)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: NowPlayingMovie
    func fetchNowPlayingMovies() -> AnyPublisher<[Movie], Error> {
        let urlString = "\(baseURL)/movie/now_playing?api_key=\(apiKey)&language=zh-TW"
        guard let url = URL(string: urlString) else {
            return Fail(error: MovieError.urlError).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .map(\.results)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: PopularMovie
    func fetchPopularMovies() -> AnyPublisher<[Movie], Error> {
        let urlString = "\(baseURL)/movie/popular?api_key=\(apiKey)&language=zh-TW"
        guard let url = URL(string: urlString) else {
            return Fail(error: MovieError.urlError).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .map(\.results)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    //MARK: TopRateMovie
    func fetchTopRatedMovies() -> AnyPublisher<[Movie], Error> {
        let urlString = "\(baseURL)/movie/top_rated?api_key=\(apiKey)&language=zh-TW"
        guard let url = URL(string: urlString) else {
            return Fail(error: MovieError.urlError).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .map(\.results)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    // MARK: MovieDetail
    func fetchMovieDetail(id: Int) -> AnyPublisher<MovieDetailModel, Error> {
        let urlString = "\(baseURL)/movie/\(id)?api_key=\(apiKey)&language=zh-TW"
        guard let url = URL(string: urlString) else {
            return Fail(error: MovieError.urlError).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieDetailModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: MovieReview
    func fetchMovieReviews(id: Int, page: Int = 1) -> AnyPublisher<[Review], Error> {
        let urlString = "\(baseURL)/movie/\(id)/reviews?api_key=\(apiKey)&language=zh-TW&page=\(page)"
        guard let url = URL(string: urlString) else {
            return Fail(error: MovieError.urlError).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ReviewResponse.self, decoder: JSONDecoder())
            .map(\.results)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}
