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
    
}


