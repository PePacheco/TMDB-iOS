//
//  MoviesListViewController.swift
//  Api-TMDB
//
//  Created by Pedro Gomes Rubbo Pacheco on 30/06/21.
//

import UIKit

class MoviesListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var popularMovies: [Movie] = []
    var popularMoviesFiltered: [Movie] = []
    var nowPlayingMovies: [Movie] = []
    var nowPlayingMoviesFiltered: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        HTTPService.shared.fetchUrl(url: "now_playing", page: 1) { [weak self] result in
            switch result {
            case .success(let movies):
                guard let self = self else { return }
                self.popularMovies = movies
                self.popularMoviesFiltered = movies
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        
        HTTPService.shared.fetchUrl(url: "popular" ,page: 1) { [weak self] result in
            switch result {
            case .success(let movies):
                guard let self = self else { return }
                self.nowPlayingMoviesFiltered = movies
                self.nowPlayingMovies = movies
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}

extension MoviesListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Popular Movies"
        }
        return "Now Playing"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.popularMoviesFiltered.count
        }
        return self.nowPlayingMoviesFiltered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell") as? MovieListTableViewCell else {
            return UITableViewCell()
        }
        let movie = indexPath.section == 0 ? popularMoviesFiltered[indexPath.row] : nowPlayingMoviesFiltered[indexPath.row]
        guard let image = HTTPService.shared.fetchMoviePoster(with: URL(string: movie.imagePath)) else {
            return UITableViewCell()
        }
        cell.setUp(image: image, title: movie.title, description: movie.description, rating: movie.rating)
        return cell
    }
}

extension MoviesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.nowPlayingMoviesFiltered = self.nowPlayingMovies
        self.popularMoviesFiltered = self.popularMovies
        if !searchText.isEmpty {
            self.nowPlayingMoviesFiltered = self.nowPlayingMovies.filter { movie in
                return movie.title.lowercased().contains(searchText.lowercased())
            }
            self.popularMoviesFiltered = self.popularMovies.filter { movie in
                return movie.title.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }
}
