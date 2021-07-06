//
//  Movie.swift
//  Api-TMDB
//
//  Created by Pedro Gomes Rubbo Pacheco on 30/06/21.
//

import UIKit

class Movie {
    let id: Int
    let title: String
    let description: String
    let rating: Int
    let image: UIImage
    let genres: [Int]
    
    init(id: Int, title: String, description: String, rating: Int, image: UIImage, genres: [Int]) {
        self.id = id
        self.title = title
        self.description = description
        self.rating = rating
        self.image = image
        self.genres = genres
    }
}
