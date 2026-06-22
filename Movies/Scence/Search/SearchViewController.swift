//
//  SearchViewController.swift
//  Movies
//
import UIKit
import Combine

class SearchViewController: UIViewController {

    // MARK: - Properties
    let viewModel = SearchViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let searchTextSubject = PassthroughSubject<String, Never>()

    // MARK: - Results State Outlets
    @IBOutlet weak var resultsView: UIView!
    @IBOutlet weak var resultsBackImageView: UIImageView!
    @IBOutlet weak var resultsTitleLabel: UILabel!
    @IBOutlet weak var resultsInfoImageView: UIImageView!
    @IBOutlet weak var resultsSearchBar: UISearchBar!
    @IBOutlet weak var moviesTableView: UITableView!

    // MARK: - Empty State Outlets
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var emptyBackImageView: UIImageView!
    @IBOutlet weak var emptyTitleLabel: UILabel!
    @IBOutlet weak var emptyInfoImageView: UIImageView!
    @IBOutlet weak var emptySearchBar: UISearchBar!
    @IBOutlet weak var emptyDescriptionImageView: UIImageView!
    @IBOutlet weak var emptyDescriptionLabel: UILabel!
    @IBOutlet weak var emptyAdviceLabel: UILabel!
    @IBOutlet weak var infoOfSearchBarLabel: UILabel!
    @IBOutlet weak var infoOfSearchBarView: UIView!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        infoOfSearchBarView.isHidden = true
        emptyStateView.isHidden = false
        infoOfSearchBarView.isHidden = true

        
        setupUI()
        setupSearchBars()
        setupTableView()
        bindViewModel()
        bindSearch()
        updateUI(for: viewModel.state)
        setupDismissTapGesture()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    // MARK: - Setup
    private func setupUI() {
        let mainColor = UIColor(hex: "#242A32")
        view.backgroundColor = mainColor
        resultsView.backgroundColor = mainColor
        emptyStateView.backgroundColor = mainColor
        moviesTableView.backgroundColor = mainColor

        resultsTitleLabel.text = "Search"
        resultsTitleLabel.textColor = .white
        resultsTitleLabel.font = UIFont.systemFont(ofSize: 16)

        emptyTitleLabel.text = "Search"
        emptyTitleLabel.textColor = .white
        emptyTitleLabel.font = UIFont.systemFont(ofSize: 16)

        resultsBackImageView.image = UIImage(systemName: "chevron.left")
        resultsBackImageView.tintColor = .white
        emptyBackImageView.image = UIImage(systemName: "chevron.left")
        emptyBackImageView.tintColor = .white

        resultsInfoImageView.image = UIImage(named: "info-circle")
        emptyInfoImageView.image = UIImage(named: "info-circle")
        emptyDescriptionImageView.image = UIImage(named: "no-results 1")
        emptyDescriptionLabel.text = "We Are Sorry, We Can Not Find The Movie :("
        emptyDescriptionLabel.textColor = UIColor(hex: "EBEBEF")
        emptyDescriptionLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        emptyDescriptionLabel.textAlignment = .center
        emptyDescriptionLabel.numberOfLines = 0
        emptyAdviceLabel.text = "Find your movie by Type title, categories, years, etc"
        emptyAdviceLabel.textColor = UIColor(hex: "92929D")
        emptyAdviceLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        emptyAdviceLabel.textAlignment = .center
        emptyAdviceLabel.numberOfLines = 0
        
        infoOfSearchBarLabel.text = "Search for movies by typing the title. Results update automatically as you type"
        infoOfSearchBarView.layer.borderColor = UIColor(hex: "#0396E4").cgColor
        infoOfSearchBarView.layer.borderWidth = 1
        
        infoOfSearchBarView.backgroundColor = UIColor(hex: "#252A33")
        infoOfSearchBarLabel.textColor = UIColor(hex: "#EBEBEF").withAlphaComponent(0.5)
        infoOfSearchBarView.layer.cornerRadius = 8
        infoOfSearchBarView.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner
        ]
    }
    private func setupSearchBars() {
        styleSearchBar(resultsSearchBar)
        styleSearchBar(emptySearchBar)
        resultsSearchBar.delegate = self
        emptySearchBar.delegate = self
    }
    private func styleSearchBar(_ searchBar: UISearchBar) {
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = .clear
        searchBar.barTintColor = .clear

        let textField = searchBar.searchTextField
        textField.backgroundColor = UIColor(hex: "#67686D")
        textField.textColor = .white
        textField.tintColor = .white
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.layer.cornerRadius = 16
        textField.clipsToBounds = true

        textField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.8)]
        )
    }
    private func setupTableView() {
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        moviesTableView.separatorStyle = .none
        moviesTableView.register(
            UINib(nibName: "SearchTableViewCell", bundle: nil),
            forCellReuseIdentifier: "SearchTableViewCell"
        )
    }
    // MARK: - Binding
    private func bindViewModel() {
        viewModel.$movies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.moviesTableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.updateUI(for: state)
            }
            .store(in: &cancellables)
    }
    private func bindSearch() {
        viewModel.bindSearch(textPublisher: searchTextSubject.eraseToAnyPublisher())
    }
    // updateUI
    private func updateUI(for state: SearchViewModel.SearchState) {
        switch state {
        case .empty:
            emptyStateView.isHidden = true
            resultsView.isHidden = true

        case .loading:
            emptyStateView.isHidden = true
            resultsView.isHidden = true

        case .results:
            emptyStateView.isHidden = true
            resultsView.isHidden = false

        case .noResults:
            emptyStateView.isHidden = false
            resultsView.isHidden = true
        }
    }
    private func goToDetails(movieId: Int) {
        let vc = DetailsViewController(nibName: "DetailsViewController", bundle: nil)
        let vm = DetailsViewModel(movieId: movieId)
        vc.viewModel = vm
        navigationController?.pushViewController(vc, animated: true)
    }
    private func goBack() {
        if let nav = navigationController, nav.viewControllers.count > 1 {
            nav.popViewController(animated: true)
        } else if let tabBar = tabBarController as? MainTabBarController {
            tabBar.switchToTab(0)
        }
    }
    private func setupDismissTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissInfoView))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    @objc private func dismissInfoView() {
        infoOfSearchBarView.isHidden = true
    }
    // MARK: - Actions
    @IBAction func backButton(_ sender: UIButton) {
        goBack()
    }
    @IBAction func infoButton(_ sender: UIButton) {
        infoOfSearchBarView.isHidden.toggle()
    }
    @IBAction func emptyInfoButton(_ sender: UIButton) {
    }
}
// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar === resultsSearchBar {
            emptySearchBar.text = searchText
        } else {
            resultsSearchBar.text = searchText
        }
        searchTextSubject.send(searchText)
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getMovieCount()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "SearchTableViewCell",
            for: indexPath
        ) as! SearchTableViewCell
        let movie = viewModel.getMovie(at: indexPath.row)
        cell.configure(movie: movie)
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = viewModel.getMovie(at: indexPath.row)
        goToDetails(movieId: movie.id)
    }
}
