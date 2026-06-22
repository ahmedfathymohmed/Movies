import UIKit
import Combine

class DetailsViewController: UIViewController {
   
    // MARK: - Properties
    var viewModel: DetailsViewModel?
    weak var coordinator: AppCoordinator?
    private var cancellables = Set<AnyCancellable>()
    var isInWatchList = false
    
    let tabs = ["About Movie", "Reviews", "Cast"]
    var selectedIndex = 0
    
    private let tapsHandler = TapsCollectionViewHandler()
    private let castHandler = CastCollectionViewHandler()
    private let reviewsHandler = ReviewsTableViewHandler()
    
    // MARK: - Outlets
    @IBOutlet weak var contanierView: UIView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var selectedMovieImage: UIImageView!
    @IBOutlet weak var selectedMovieSmallImage: UIImageView!
    @IBOutlet weak var saveMarkImage: UIImageView!
    @IBOutlet weak var saveMarkButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var typeOfMovieImage: UIImageView!
    @IBOutlet weak var typeOfMovieLabel: UILabel!
    @IBOutlet weak var dateOfMovieImage: UIImageView!
    @IBOutlet weak var dateOfMovieLabel: UILabel!
    @IBOutlet weak var timeOfMovieImage: UIImageView!
    @IBOutlet weak var timeOfMovieLabel: UILabel!
    @IBOutlet weak var aboutMovieLabel: UILabel!
    @IBOutlet weak var aboutMovieView: UIView!
    @IBOutlet weak var reviewMovieView: UIView!
    @IBOutlet weak var creditsMovieView: UIView!
    @IBOutlet weak var tapsCollectionView: UICollectionView!
    @IBOutlet weak var reviewMovieTableView: UITableView!
    @IBOutlet weak var castCollectionView: UICollectionView!
    
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var noReviewsLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabsCollectionView()
        setupReviewsTableView()
        setupCastCollectionView()
        showLoading()

        showView(for: 0)
        
        bindViewModel()
        bindViewModelReview()
        bindMovieCredits()

        viewModel?.fetchMoviesDetails()
        backButton.setTitle("", for: .normal)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .white
        saveMarkImage.tintColor = .white
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    // MARK: - Show/Hide Views
    func showView(for index: Int) {
        aboutMovieView.isHidden   = (index != 0)
        reviewMovieView.isHidden  = (index != 1)
        creditsMovieView.isHidden = (index != 2)
    }
    // MARK: - Setups
    private func setupTabsCollectionView() {
        tapsCollectionView.delegate = tapsHandler
        tapsCollectionView.dataSource = tapsHandler
        tapsCollectionView.backgroundColor = .clear
        tapsCollectionView.showsHorizontalScrollIndicator = false
        tapsCollectionView.register(
            UINib(nibName: "SelectedTapCell", bundle: nil),
            forCellWithReuseIdentifier: "SelectedTapCell"
        )
        tapsHandler.onTabSelected = { [weak self] index in
            guard let self = self else { return }
            self.showView(for: index)
            if index == 1 {
                self.viewModel?.fetchMovieReviews()
            }
            if index == 2 {
                self.viewModel?.fetchMovieCredits()
            }
        }
    }
    
    private func setupReviewsTableView() {
        reviewMovieTableView.delegate = reviewsHandler
        reviewMovieTableView.dataSource = reviewsHandler
        reviewMovieTableView.register(
            UINib(nibName: "MovieReviewsCell", bundle: nil),
            forCellReuseIdentifier: "MovieReviewsCell"
        )
    }
    private func setupCastCollectionView() {
        castCollectionView.delegate = castHandler
        castCollectionView.dataSource = castHandler
        castCollectionView.backgroundColor = .clear
        castCollectionView.showsHorizontalScrollIndicator = false
        castCollectionView.register(
            UINib(nibName: "CastCell", bundle: nil),
            forCellWithReuseIdentifier: "CastCell"
        )
    }
    
    // MARK: - Binding
    private func bindViewModel() {
        viewModel?.$detailResponse
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                guard let movie = response else { return }
                self?.updateUI(with: movie)
                self?.hideLoading()
            }
            .store(in: &cancellables)
        
        viewModel?.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { error in
                if let error = error { print("Error: \(error)") }
                self.hideLoading()
            }
            .store(in: &cancellables)
    }
    
    private func bindViewModelReview() {
        viewModel?.$reviews
            .receive(on: DispatchQueue.main)
            .sink { [weak self] reviews in
                guard let self = self else { return }
        
                self.reviewsHandler.reviews = reviews
                self.reviewMovieTableView.reloadData()
                
                self.noReviewsLabel.isHidden = !reviews.isEmpty
                self.reviewMovieTableView.isHidden = reviews.isEmpty
            }
            .store(in: &cancellables)
    }
    
    private func bindMovieCredits() {
        viewModel?.$cast
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cast in
                guard let self = self else { return }
                self.castHandler.cast = cast
                self.castCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    private func showLoading() {
        loadingIndicator.startAnimating()
        contanierView.alpha = 0.5
    }

    private func hideLoading() {
        loadingIndicator.stopAnimating()
        UIView.animate(withDuration: 0.0) {
            self.contanierView.alpha = 1
        }
    }
    
    // MARK: - UI Updates
    private func updateUI(with movie: DetailResponse) {
        bindMovieData(movie)
        isInWatchList = WatchListStorage().getMovies().contains { $0.id == movie.id }
        updateButton()
    }
    
    
    private func bindMovieData(_ movie: DetailResponse) {
        contanierView.backgroundColor = UIColor(hex: "#242A32")
        movieTitleLabel.text = movie.title ?? "N/A"
        movieTitleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        movieTitleLabel.textColor = .white
        
        
        ratingLabel.text = String(format: "%.1f", movie.voteAverage ?? 0.0)
        ratingLabel.textColor = UIColor(hex: "#FF8700")
        ratingLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        ratingLabel.layer.borderColor = UIColor(hex: "#FF8700").cgColor
        ratingView.backgroundColor = UIColor(hex: "#252836").withAlphaComponent(0.5)
        ratingView.layer.cornerRadius = 8
        ratingImage.image = UIImage(named: "Star")?.withRenderingMode(.alwaysTemplate)
        ratingImage.tintColor = UIColor(hex: "#FF8700")

        typeOfMovieImage.image = UIImage(named: "Ticket")
        timeOfMovieImage.image = UIImage(named: "Clock")
        dateOfMovieImage.image = UIImage(named: "CalendarBlank")
        typeOfMovieLabel.font = .systemFont(ofSize: 12, weight: .medium)
        typeOfMovieLabel.textColor = .white
        dateOfMovieLabel.font = .systemFont(ofSize: 12, weight: .medium)
        dateOfMovieLabel.textColor = .white
        timeOfMovieLabel.font = .systemFont(ofSize: 12, weight: .medium)
        timeOfMovieLabel.textColor = .white
        typeOfMovieLabel.text = movie.genres?.first?.name ?? "Unknown"
        dateOfMovieLabel.text = movie.releaseDate ?? "N/A"
        timeOfMovieLabel.text = "\(movie.runtime ?? 0) mins"
        
        if let overview = movie.overview, !overview.isEmpty {
            aboutMovieLabel.text = overview
        } else {
            aboutMovieLabel.text = "No description available for this movie yet"
        }
        aboutMovieLabel.font = .systemFont(ofSize: 14, weight: .medium)
        aboutMovieLabel.textColor = .white
        
        selectedMovieSmallImage.layer.cornerRadius = 10
        selectedMovieSmallImage.layer.borderColor = UIColor.orange.cgColor
        selectedMovieSmallImage.layer.borderWidth = 1
        
        noReviewsLabel.text = "No reviews yet for this movie."
        noReviewsLabel.textColor = .white
        noReviewsLabel.font = .systemFont(ofSize: 14, weight: .medium)

        
        guard let posterPath = movie.posterPath, !posterPath.isEmpty else {
            self.selectedMovieImage.image = UIImage(named: "placeholder")
            self.selectedMovieSmallImage?.image = UIImage(named: "placeholder")
            return
        }
        Task {
            if let downloadedImage = await ImageLoader.shared.loadImage(from: posterPath) {
                await MainActor.run {
                    self.selectedMovieImage.image = downloadedImage
                    self.selectedMovieSmallImage?.image = downloadedImage
                }
            } else {
                await MainActor.run {
                    self.selectedMovieImage.image = UIImage(named: "placeholder")
                    self.selectedMovieSmallImage?.image = UIImage(named: "placeholder")
                }
            }
        }
    }
    func updateButton() {
        let imageName = isInWatchList ? "bookmark.fill" : "bookmark"
        saveMarkImage.image = UIImage(systemName: imageName)
        saveMarkImage.tintColor = isInWatchList ? UIColor(hex: "#0296E5") : .white
    }
    
    // MARK: - Actions
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveMarkButton(_ sender: UIButton) {
        isInWatchList.toggle()

        guard let movie = viewModel?.detailResponse,
              let id = movie.id else { return }
        let year = String(movie.releaseDate?.prefix(4) ?? "")
        let duration = "\(movie.runtime ?? 0) minutes"
        let genre = movie.genres?.first?.name ?? "Unknown"
        let watchMovie = WatchListModel(
            id: id,
            title: movie.title ?? "",
            posterPath: movie.posterPath ?? "",
            rating: movie.voteAverage ?? 0,
            genre: genre,
            year: year,
            duration: duration
        )
        if isInWatchList {
            WatchListStorage().save(movie: watchMovie)
        } else {
            WatchListStorage().remove(movieId: watchMovie.id)
        }
        updateButton()
    }
}
