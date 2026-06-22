//
//  WatchListCellTableViewCell.swift
//  Movies
//
//  Created by Ahmed Fathy on 22/04/2026.
//

import UIKit

class WatchListCellTableViewCell: UITableViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var nameOfMovieLabel: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var typeOfMovieImage: UIImageView!
    @IBOutlet weak var typeOfMovieLabel: UILabel!
    @IBOutlet weak var dateOfMovieImage: UIImageView!
    @IBOutlet weak var dateOfMovieLabel: UILabel!
    @IBOutlet weak var timeOfMovieImage: UIImageView!
    @IBOutlet weak var timeOfMovieLabel: UILabel!

    private var downloadTask: Task<Void, Never>?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()

    }
    func setupUI(){
        contentView.backgroundColor = UIColor(hex: "#242A32")
        movieImage.layer.cornerRadius = 16
        nameOfMovieLabel.textColor = .white
        typeOfMovieImage.image = UIImage(named: "Ticket")
        typeOfMovieLabel.textColor = .white
        dateOfMovieImage.image = UIImage(named: "CalendarBlank")
        dateOfMovieLabel.textColor = .white
        timeOfMovieImage.image = UIImage(named: "Clock")
        timeOfMovieLabel.textColor = .white
        ratingImage.image = UIImage(named: "Star")
        ratingLabel.textColor = .white
        ratingLabel.textColor = UIColor(hex: "#FF8700")
        
        nameOfMovieLabel.font = .systemFont(ofSize: 20, weight: .regular)
        
        ratingLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        typeOfMovieLabel.font = .systemFont(ofSize: 12, weight: .regular)
        dateOfMovieLabel.font = .systemFont(ofSize: 12, weight: .regular)
        timeOfMovieLabel.font = .systemFont(ofSize: 12, weight: .regular)

    }
    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        movieImage.image = UIImage(named: "placeholder")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func configure(movie: WatchListModel) {
        nameOfMovieLabel.text = movie.title
        ratingLabel.text = "\(String(format: "%.1f", movie.rating))"
        typeOfMovieLabel.text = movie.genre
        dateOfMovieLabel.text = movie.year
        timeOfMovieLabel.text = movie.duration
        
        guard let path = movie.posterPath else { return }
        downloadTask = Task {
            if let image = await ImageLoader.shared.loadImage(from: path) {
                await MainActor.run {
                    self.movieImage.image = image
                }
            }
        }
    }
}
