//
//  MovieDetailsViewController.swift
//  Api-TMDB
//
//  Created by Pedro Gomes Rubbo Pacheco on 01/07/21.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var movie: Movie?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let movie = movie else { return }
        let ret = HTTPService.shared.fetchGenres(of: movie)
        let genres = ret.isEmpty ? "No genres where found" : ret
        genreLabel.text = genres
        posterImageView.image = movie.image
        posterImageView.layer.cornerRadius = 8
        titleLabel.text = movie.title
        let mutableString = NSMutableAttributedString(attachment: NSTextAttachment(image: UIImage(systemName: "star")!))
        mutableString.append(NSAttributedString(string: " \(movie.rating)"))
        ratingLabel.attributedText = mutableString
        descriptionLabel.text = movie.description
    }

}
