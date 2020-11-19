//
//  MovieController.swift
//  FavoriteMovies
//
//  Created by Jeremy Taylor on 11/18/20.
//

import UIKit

class MovieController {
    static let apiKey = "f98008c253a6cc53e0b5b32240a63fae"
    static let baseURL = URL(string: "https://api.themoviedb.org/3/search/movie")!
    
    static let castBaseURL = URL(string: "https://api.themoviedb.org/3/movie")!
    
    static var imageBaseURL = URL(string: "https://image.tmdb.org/t/p/original")
    
    typealias CompletionHandler = (Result<[Movie], MovieError>) -> Void
    typealias ImageCompletionHandler = (Result<UIImage, MovieError>) -> Void
    typealias CastCompletionHandler = (Result<[String], MovieError>) -> Void
    
    static func searchForMovie(with searchTerm: String, completion: @escaping CompletionHandler) {
            var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
            let queryParameters = ["query": searchTerm,
                                   "api_key": apiKey]
            components?.queryItems = queryParameters.map({URLQueryItem(name: $0.key, value: $0.value)})
            
            guard let requestURL = components?.url else {
                completion(.failure(.invalidURL))
                return
            }
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData))}
            
            do {
                let results = try JSONDecoder().decode(TopLevelObject.self, from: data).results
                var movies: [Movie] = []
                for result in results {
                    let movie = result
                    movies.append(movie)
                }
                completion(.success(movies))
            } catch {
                completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    static func fetchImageFor(movie: Movie, completion: @escaping ImageCompletionHandler) {
        
        guard let finalImageURL = imageBaseURL?.appendingPathComponent(movie.posterImage) else { return completion(.failure(.invalidURL))}
        
        URLSession.shared.dataTask(with: finalImageURL) { (data, _, error) in
            if let error = error {
                completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData))}
            
            guard let posterImage = UIImage(data: data) else { return completion(.failure(.unableToDecode))}
            completion(.success(posterImage))
        }.resume()
    }
    
    static func fetchCastFor(movie: Movie, completion: @escaping CastCompletionHandler) {
        let finalURL = castBaseURL.appendingPathComponent("\(movie.id)").appendingPathComponent("credits")
        
        var components = URLComponents(url: finalURL, resolvingAgainstBaseURL: true)
        
    
        components?.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        guard let requestURL = components?.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        print(requestURL)
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData))}
            
            guard let castResult = try? JSONDecoder().decode(CastTopLevelObject.self, from: data).cast else { return completion(.failure(.unableToDecode))}
            
            var castArray: [String] = []
            
            for cast in castResult {
                castArray.append(cast.name)
            }
            completion(.success(castArray))
            
        }.resume()
    }

    
} // End of class
