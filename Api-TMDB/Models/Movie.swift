//
//  Movie.swift
//  Api-TMDB
//
//  Created by Pedro Gomes Rubbo Pacheco on 30/06/21.
//

import UIKit

struct Movie {
    let id: Int
    let title: String
    let description: String
    let rating: Int
    let image: UIImage
    let genres: [Int]
}
