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
    
    private let apiKey = "a704c1ee4f1214cebbb5a43c01986dbb"
    private let baseURL = "https://api.themoviedb.org/3"
    
    func fetchMovies(search:String) -> AnyPublisher<[Movie], Error> {
        guard let encodedSearch = search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return Fail(error: MovieError.urlError).eraseToAnyPublisher()
        }
        let urlString = "\(baseURL)/search/movie?api_key=\(apiKey)&query=\(encodedSearch)"
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
}

/*class MovieHTTPClient{
 
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
}*/
