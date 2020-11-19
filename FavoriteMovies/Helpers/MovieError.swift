//
//  MovieError.swift
//  FavoriteMovies
//
//  Created by Jeremy Taylor on 11/18/20.
//

import Foundation

enum MovieError: LocalizedError {
    
    case invalidURL
    case thrownError(Error)
    case noData
    case unableToDecode
 
    var errorDescription: String {
        switch self {
        case .invalidURL:
            return "The server failed to reach the necessary URL."
        case .thrownError(let error):
            return "Opps, there was an error: \(error.localizedDescription)"
        case .noData:
            return "The server failed to load any data."
        case .unableToDecode:
            return "There was an error when trying to load the data."
        }
    }
}
