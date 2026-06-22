//
//  SearchTableViewCell.swift
//  Movies
//
//  Created by Ahmed Fathy on 12/05/2026.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    // MARK: - Labels

    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieRateLabel: UILabel!
    @IBOutlet weak var movieGenreLabel: UILabel!
    @IBOutlet weak var movieYearLabel: UILabel!
    @IBOutlet weak var movieDurationLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!

    // MARK: - Icons
    @IBOutlet weak var rateIconImageView: UIImageView!
    @IBOutlet weak var genreIconImageView: UIImageView!
    @IBOutlet weak var yearIconImageView: UIImageView!
    @IBOutlet weak var durationIconImageView: UIImageView!

    private var downloadTask: Task<Void, Never>?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        movieImageView.image = UIImage(named: "placeholder")
    }
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        movieTitleLabel.textColor = .white
        movieYearLabel.textColor = .white
        movieGenreLabel.textColor = .white
        movieDurationLabel.textColor = .white
        movieRateLabel.textColor = .orange
        
        movieTitleLabel.font = .systemFont(ofSize: 20)
        movieTitleLabel.numberOfLines = 1
        movieTitleLabel.lineBreakMode = .byTruncatingTail
        movieRateLabel.font = .systemFont(ofSize: 14)
        movieGenreLabel.font = .systemFont(ofSize: 14)
        movieYearLabel.font = .systemFont(ofSize: 14)
        movieDurationLabel.font = .systemFont(ofSize: 14)
        movieImageView.layer.cornerRadius = 16
        rateIconImageView.image = UIImage(named: "Star")
        genreIconImageView.image = UIImage(named: "Ticket")
        yearIconImageView.image = UIImage(named: "CalendarBlank")
        durationIconImageView.image = UIImage(named: "Clock")

    }
    // MARK: - Configure
    func configure(movie: WatchListModel) {
        movieTitleLabel.text = movie.title
        movieRateLabel.text = "\(String(format: "%.1f", movie.rating))"
        movieYearLabel.text = movie.year
        movieGenreLabel.text = movie.genre
        movieDurationLabel.text = movie.duration

        guard let path = movie.posterPath else { return }
        downloadTask = Task {
            if let image = await ImageLoader.shared.loadImage(from: path) {
                await MainActor.run {
                    self.movieImageView.image = image
                }
            }
        }
    }
}
extension UIImageView {
    func loadImage(from stringURL: String) {
        guard let url = URL(string: stringURL) else {
            return
        }
        URLSession.shared.dataTask(with: url) {
            [weak self] data, _, _ in
            guard let data = data else {
                return
            }
            DispatchQueue.main.async {
                self?.image = UIImage(data: data)
            }
        }.resume()
    }
}


