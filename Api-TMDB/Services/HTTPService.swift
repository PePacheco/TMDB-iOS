//
//  HTTPService.swift
//  Api-TMDB
//
//  Created by Pedro Gomes Rubbo Pacheco on 30/06/21.
//

import UIKit

enum HTTPError: Error {
    case urlNotFound
    case badRequest
}

final class HTTPService {
    
    public static var shared: HTTPService = HTTPService()
    
    private init(){}
    
    public func fetchUrl(url: String, page: Int, completion: @escaping (Result<[Movie], HTTPError>) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(url)?api_key=84409706477b6eec19f50e5fe64c664c&language=en-US&page=\(page)") else {
            completion(.failure(.urlNotFound))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil,
                  let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed),
                  let dictionary = json as? [String: Any],
                  let movies = dictionary["results"] as? [[String: Any]]
            else {
                completion(.failure(.badRequest))
                return
            }
            var results: [Movie] = []
            for movie in movies {
                guard let id = movie["id"] as? Int, let title = movie["title"] as? String, let description = movie["overview"] as? String, let rating = movie["vote_average"] as? Int, let path = movie["backdrop_path"] as? String else {
                    continue
                }
                results.append(Movie(id: id, title: title, description: description, rating: rating, imagePath: "https://image.tmdb.org/t/p/w500\(path)"))
            }
            completion(.success(results))
        }
        .resume()
    }
    
    public func fetchMoviePoster(with url: URL?) -> UIImage? {
        guard let url = url, let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }
    
}
