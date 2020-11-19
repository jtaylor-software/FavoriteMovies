//
//  SearchedMoviesTableViewController.swift
//  FavoriteMovies
//
//  Created by Jeremy Taylor on 11/18/20.
//

import UIKit

class SearchedMoviesTableViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return movies.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath)
        let movie = movies[indexPath.row]
        
        cell.textLabel?.text = movie.title

        return cell
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destinationVC = segue.destination as? MovieDetailViewController else { return }
            
            let movie = movies[indexPath.row]
            destinationVC.movie = movie
        }
    }
}

extension SearchedMoviesTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else { return }
                
                MovieController.searchForMovie(with: searchTerm) { result in
                    if let movies = try? result.get() {
                        self.movies = movies
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }

    }
}
