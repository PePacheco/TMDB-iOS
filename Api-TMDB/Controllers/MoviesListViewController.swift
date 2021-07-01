//
//  MoviesListViewController.swift
//  Api-TMDB
//
//  Created by Pedro Gomes Rubbo Pacheco on 30/06/21.
//

import UIKit

class MoviesListViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var popularMovies: [Movie] = []
    var popularMoviesFiltered: [Movie] = []
    var nowPlayingMovies: [Movie] = []
    var nowPlayingMoviesFiltered: [Movie] = []

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        searchBar.delegate = self
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        self.fetchMovies(type: "now_playing", page: 1)
        self.fetchMovies(type: "popular", page: 1)
    }
    
    // MARK: - Actions
    
    private func fetchMovies(type: String, page: Int) {
        HTTPService.shared.fetchMoviesByType(type: type, page: 1) { [weak self] result in
            switch result {
            case .success(let movies):
                guard let self = self else { return }
                if type == "popular" {
                    self.popularMovies = movies
                    self.popularMoviesFiltered = movies
                } else {
                    self.nowPlayingMovies = movies
                    self.nowPlayingMoviesFiltered = movies
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? MovieDetailsViewController, segue.identifier == "showMovieDetails", let sender = sender as? Movie else {
            return
        }
        vc.movie = sender
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
        cell.setUp(title: movie.title, description: movie.description, rating: movie.rating, image: movie.image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = indexPath.section == 0 ? popularMoviesFiltered[indexPath.row] : nowPlayingMoviesFiltered[indexPath.row]
        performSegue(withIdentifier: "showMovieDetails", sender: movie)
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
