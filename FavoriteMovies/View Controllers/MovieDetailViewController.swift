//
//  MovieDetailViewController.swift
//  FavoriteMovies
//
//  Created by Jeremy Taylor on 11/18/20.
//

import UIKit

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var castLabel: UILabel!
    
    
    
    var movie: Movie? {
        didSet {
            updateViews()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    func updateViews() {
        guard let movie = movie, isViewLoaded else { return }
        
        titleLabel.text = movie.title
        voteLabel.text = "Average rating: \(movie.voteAverage)"
        releaseDateLabel.text = "Released: \(movie.releaseDate)"
        overviewLabel.text = movie.overview
        fetchPosterImage()
        fetchCastList()
    }
    
    func fetchPosterImage() {
        guard let movie = movie else { return }
        MovieController.fetchImageFor(movie: movie) { (result) in
            if let image = try? result.get() {
                DispatchQueue.main.async {
                    self.posterImageView.image = image
                }
            }
        }
    }
    
    func fetchCastList() {
        guard let movie = movie else { return }
        MovieController.fetchCastFor(movie: movie) { (result) in
            if let cast = try? result.get() {
                DispatchQueue.main.async {
                    self.castLabel.text = "Cast: \n\(cast.joined(separator: ", "))"
                }
            }
        }
    }
}
