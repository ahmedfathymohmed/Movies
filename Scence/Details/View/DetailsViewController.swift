//
//  DetailsViewController.swift
//  Movies App Task
//
//  Created by Ahmed Fathy on 24/01/2026.

import UIKit
import Combine

class DetailsViewController: UIViewController {
    
    var viewModel: DetailsViewModel?
    weak var coordinator: AppCoordinator?
    private var cancellables = Set<AnyCancellable>()
    
    @IBOutlet weak var contanierView: UIView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var selectedMovieImage: UIImageView!
    
    @IBOutlet weak var selectedMovieSmallImge: UIImageView!
    @IBOutlet weak var homepageLabel: UILabel!
    @IBOutlet weak var languagesLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var revenueLabel: UILabel!
    
    @IBOutlet weak var homePageLabelValue: UILabel!
    @IBOutlet weak var languagesLabelValue: UILabel!
    @IBOutlet weak var budgetLabelValue: UILabel!
    @IBOutlet weak var statusLabelValue: UILabel!
    @IBOutlet weak var runtimeLabelValue: UILabel!
    @IBOutlet weak var revenueLabelValue: UILabel!
    @IBOutlet weak var backImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(true, animated: false)
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            navigationController?.setNavigationBarHidden(false, animated: false)
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()

        viewModel?.fetchMoviesDetails()
        
        backImageView.image = UIImage(named: "back_1")
        backImageView.tintColor = .white

    }
    private func updateUI(with movie: DetailResponse) {
        setupStaticUI()
        bindMovieData(movie)
        loadPoster(path: movie.posterPath)
    }
    
    private func bindViewModel() {
        viewModel?.$detailResponse
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                guard let movie = response else { return }
                self?.updateUI(with: movie)
            }
            .store(in: &cancellables)
        
        viewModel?.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { error in
                if let error = error {
                    print(" Error: \(error)")
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupStaticUI() {
        contanierView.backgroundColor = .black
        
        homepageLabel.text = "Homepage"
        languagesLabel.text = "Language"
        statusLabel.text = "Status"
        budgetLabel.text = "Budget"
        runtimeLabel.text = "Runtime"
        revenueLabel.text = "Revenue"
        
        let labels = [
            homepageLabel,
            languagesLabel,
            statusLabel,
            budgetLabel,
            runtimeLabel,
            revenueLabel
        ]
        
        labels.forEach {
            $0?.font = .systemFont(ofSize: 15, weight: .bold)
            $0?.textColor = .white
        }
    }
    
    private func bindMovieData(_ movie: DetailResponse) {
        movieTitleLabel.text = movie.title ?? "N/A"
        movieTitleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        movieTitleLabel.textColor = .white
        
        releaseDateLabel.text = movie.releaseDate ?? "N/A"
        releaseDateLabel.font = .systemFont(ofSize: 15)
        releaseDateLabel.textColor = .white
        
        descriptionLabel.text = movie.overview ?? "No description available"
        descriptionLabel.font = .systemFont(ofSize: 16, weight: .medium)
        descriptionLabel.textColor = .white
        
        homePageLabelValue.text = movie.homepage ?? "N/A"
        homePageLabelValue.font = .systemFont(ofSize: 12, weight: .regular)
        homePageLabelValue.textColor = .blue
        
        languagesLabelValue.text = movie.spokenLanguages?.first?.englishName ?? "Unknown"
        languagesLabelValue.font = .systemFont(ofSize: 12, weight: .regular)
        languagesLabelValue.textColor = .white
        
        statusLabelValue.text = movie.status ?? "N/A"
        statusLabelValue.font = .systemFont(ofSize: 12, weight: .regular)
        statusLabelValue.textColor = .white
        
        budgetLabelValue.text = "$\(movie.budget ?? 0)"
        budgetLabelValue.font = .systemFont(ofSize: 12, weight: .regular)
        budgetLabelValue.textColor = .white
        
        revenueLabelValue.text = "$\(movie.revenue ?? 0)"
        revenueLabelValue.font = .systemFont(ofSize: 12, weight: .regular)
        revenueLabelValue.textColor = .white
        
        runtimeLabelValue.text = "\(movie.runtime ?? 0) min"
        runtimeLabelValue.font = .systemFont(ofSize: 12, weight: .regular)
        runtimeLabelValue.textColor = .white
    }
    
    
    private func loadPoster(path: String?) {
        guard let path = path else {
            selectedMovieImage.image = UIImage(named: "placeholder")
            selectedMovieSmallImge.image = UIImage(named: "placeholder")
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
        selectedMovieImage.image = image
        selectedMovieSmallImge.image = image
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        coordinator?.goBack()
    }
}
