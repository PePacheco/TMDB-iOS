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
    
    private var genres: [Genre] = []
    
    private init(){
        self.fetchGenresInternal()
    }
    
    private func fetchGenresInternal() {
        guard let url = URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=\(Constants.API_KEY_V3)") else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil,
                  let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed),
                  let dictionary = json as? [String: Any],
                  let genres = dictionary["genres"] as? [[String: Any]]
            else {
                return
            }
            var ret: [Genre] = []
            for genre in genres {
                guard let id = genre["id"] as? Int, let name = genre["name"] as? String else { continue }
                ret.append(Genre(id: id, name: name))
            }
            self.genres = ret
        }
        .resume()
    }
    
    public func fetchMoviesByType(type: String, page: Int, completion: @escaping (Result<[Movie], HTTPError>) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(type)?api_key=\(Constants.API_KEY_V3)&language=en-US&page=\(page)") else {
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
                guard let id = movie["id"] as? Int, let title = movie["title"] as? String, let description = movie["overview"] as? String, let rating = movie["vote_average"] as? Int, let path = movie["backdrop_path"] as? String, let genres = movie["genre_ids"] as? [Int] else {
                    continue
                }
                guard let image = HTTPService.shared.fetchMoviePoster(with: URL(string: "https://image.tmdb.org/t/p/w500\(path)")) else { continue }
                results.append(Movie(id: id, title: title, description: description, rating: rating, image: image, genres: genres))
            }
            completion(.success(results))
        }
        .resume()
    }
    
    public func fetchGenres(of movie: Movie) -> String {
        var ret = ""
        for genre in self.genres {
            if movie.genres.contains(genre.id) {
                ret += genre.name + ", "
            }
        }
        return String(ret.dropLast(2))
    }
    
    public func fetchMoviePoster(with url: URL?) -> UIImage? {
        guard let url = url, let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }
    
}
