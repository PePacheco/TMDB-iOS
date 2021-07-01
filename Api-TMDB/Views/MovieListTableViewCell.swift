//
//  MovieListTableViewCell.swift
//  Api-TMDB
//
//  Created by Pedro Gomes Rubbo Pacheco on 30/06/21.
//

import UIKit

class MovieListTableViewCell: UITableViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUp(image: UIImage, title: String, description: String, rating: Int) {
        movieImageView.image = image
        movieImageView.layer.cornerRadius = 8
        titleLabel.text = title
        descriptionLabel.text = description
        ratingLabel.text = "* \(rating)"
    }

}
