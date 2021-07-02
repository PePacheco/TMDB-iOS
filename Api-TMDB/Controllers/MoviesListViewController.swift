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
    
    var searchController = UISearchController(searchResultsController: nil)
    var page: Int = 2
    var popularMovies: [Movie] = []
    var popularMoviesFiltered: [Movie] = []
    var nowPlayingMovies: [Movie] = []
    var nowPlayingMoviesFiltered: [Movie] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.fetchMovies(type: "popular", page: 1)
        self.fetchMovies(type: "now_playing", page: 1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? MovieDetailsViewController, segue.identifier == "showMovieDetails", let sender = sender as? Movie else {
            return
        }
        vc.movie = sender
    }
    
    // MARK: - Actions
    private func fetchMovies(type: String, page: Int, clean: Bool = false) {
        HTTPService.shared.fetchMoviesByType(type: type, page: page) { [weak self] result in
            switch result {
            case .success(let movies):
                guard let self = self else { return }
                if clean {
                    self.page = 2
                    if type == "popular" {
                        self.popularMovies = []
                        self.popularMoviesFiltered = []
                    } else {
                        self.nowPlayingMovies = []
                        self.nowPlayingMoviesFiltered = []
                    }
                }
                if type == "popular" {
                    self.popularMovies += movies
                    self.popularMoviesFiltered += movies
                } else {
                    self.nowPlayingMovies += movies
                    self.nowPlayingMoviesFiltered += movies
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configure() {
        navigationController?.navigationBar.prefersLargeTitles = true
        let refreshable = UIRefreshControl()
        
        tableView.refreshControl = refreshable
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        
    }
    
    @objc func handleRefresh() {
        self.fetchMovies(type: "now_playing", page: 1, clean: true)
        self.fetchMovies(type: "popular", page: 1, clean: true)
        self.tableView.refreshControl?.endRefreshing()
    }
    
    func scrollToFirstRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == tableView,
              (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height else { return }
        
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        self.fetchMovies(type: "popular", page: page)
        self.fetchMovies(type: "now_playing", page: page)
        page += 1
    }
    
}

extension MoviesListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
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
