//
//  MovieModel.swift
//  MVVM_SideProject
//
//  Created by Willy Hsu on 2025/4/16.
//

import Foundation

struct MovieResponse:Codable{
    let Search:[Movie]
}

struct Movie:Codable{
    let title:String
    let year:String
    let imdbID:String
    let type:String
    let poster:String
    
    enum CodingKeys:String, CodingKey{
        case title = "Title"
        case year = "Year"
        case imdbID = "imdbID"
        case type = "Type"
        case poster = "Poster"
    }
}
