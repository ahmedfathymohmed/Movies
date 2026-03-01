//
//  MoviesCollectionView.swift
//  Movies App Task
//
//  Created by Ahmed Fathy on 20/01/2026.
//
import UIKit

class MoviesCollectionView: UICollectionViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieYearLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func setUpMoiveCell(with movie: Movie) {
        movieNameLabel.text = movie.title
        movieYearLabel.text = movie.releaseDate
        loadPoster(path: movie.posterPath)
    }
    private func loadPoster(path: String?) {
        guard let path = path else {
            movieImageView.image = UIImage(named: "placeholder")
            return
        }
        
        Task { [weak self] in
            guard let self = self else { return }
            let image = await ImageLoader.shared.loadImage(from: path)
            await self.updateImages(image)
        }
    }
    @MainActor
    private func updateImages(_ image: UIImage?) {
        movieImageView.image = image
    }
}
