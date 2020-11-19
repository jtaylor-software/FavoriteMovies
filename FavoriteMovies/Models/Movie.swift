//
//  Movie.swift
//  FavoriteMovies
//
//  Created by Jeremy Taylor on 11/18/20.
//

import Foundation

struct TopLevelObject: Decodable {
    let results: [Movie]
}

struct Movie: Decodable {
    let id: Int
    let title: String
    let voteAverage: Double
    let overview: String
    let releaseDate: String
    let posterImage: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case voteAverage = "vote_average"
        case overview
        case releaseDate = "release_date"
        case posterImage = "poster_path"
    }
}

struct CastTopLevelObject: Decodable {
    let cast: [Cast]
}

struct Cast: Decodable {
    let name: String
}
