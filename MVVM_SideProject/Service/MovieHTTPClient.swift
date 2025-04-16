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
    
    func fetchMovies(search:String) -> AnyPublisher<[Movie], Error> {
        guard let encodedSearch = search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let movieListURL = URL(string: "https://www.omdbapi.com/?s=\(encodedSearch)&apikey=b2c1ea18") else{
            return Fail(error: MovieError.urlError).eraseToAnyPublisher()
        }
        return  URLSession.shared.dataTaskPublisher(for: movieListURL)
            .map(\.data)
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .map(\.Search)
            .receive(on: DispatchQueue.main)
            .catch { error -> AnyPublisher<[Movie], Error> in
                return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
    }
}
