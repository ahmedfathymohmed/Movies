//
//  HomeViewController.swift
//  Movies App Task
//
//  Created by Ahmed Fathy on 19/12/2025.
//

import UIKit
import Combine

class HomeViewController: UIViewController , UICollectionViewDelegateFlowLayout{
    
    private var cancellables = Set<AnyCancellable>()
    private let searchSubject = PassthroughSubject<String, Never>()
    private let ViewModel = HomeViewModel()
    private var movies: [Movie] = []
    
    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoriesListCollectionView: UICollectionView!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        if collectionView == categoriesListCollectionView {
            return CGSize(width: 120, height: 30)
        }
        let columns: CGFloat = 3
        let spacing: CGFloat = 10
        let horizontalInsets: CGFloat = 20
        let availableWidth = collectionView.bounds.width - horizontalInsets - (spacing * (columns - 1))
        let itemWidth = floor(availableWidth / columns)
        let itemHeight = itemWidth * 1.5
        return CGSize(width: itemWidth, height: itemHeight)
    }
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerCollectionViewCells()
        setupCollectionViewDelegates()
        bindViewModel()
        setupMoviesCollectionViewLayout()
        ViewModel.fetchMovies(endpoint: .popular)
        ViewModel.bindSearch(
            textPublisher: searchSubject.eraseToAnyPublisher()
        )
        ViewModel.fetchMovies(endpoint: .popular)
    }
    func setupUI(){
        searchBar.delegate = self
        moviesCollectionView.delaysContentTouches = false
        categoriesListCollectionView.delaysContentTouches = false
        let textField = searchBar.searchTextField
        
        textField.backgroundColor = UIColor(hex: "#3A3F47")
        textField.textColor = .white
        textField.tintColor = .white
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        
        searchBar.searchBarStyle = .minimal
        searchBar.isTranslucent = true
        searchBar.backgroundImage = UIImage()
        searchBar.barTintColor = .clear
        searchBar.backgroundColor = .clear
        
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [.foregroundColor: UIColor.lightGray]
        )
        addKeyboardDoneButton()
        categoriesListCollectionView.backgroundColor = UIColor(hex: "#242A32")
        moviesCollectionView.backgroundColor = UIColor(hex: "#242A32")
        view.backgroundColor = UIColor(hex: "#242A32")
        titleLabel.text = "What do you want to watch?"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
    }
    private func addKeyboardDoneButton() {
        let toolbar = UIToolbar(
            frame: CGRect(
                x: 0,
                y: 0,
                width: UIScreen.main.bounds.width,
                height: 44
            )
        )
        toolbar.barStyle = .black
        toolbar.tintColor = UIColor(hex: "#0296E5")
        let flexible = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        let done = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(dismissKeyboard)
        )
        toolbar.items = [flexible, done]
        searchBar.searchTextField.inputAccessoryView = toolbar
    }
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    private func setupMoviesCollectionViewLayout() {
        
        guard let layout = moviesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: 10,
            bottom: 20,
            right: 10
        )
    }
    // MARK: - Setup Methods
    private func registerCollectionViewCells() {
        categoriesListCollectionView.register(
            UINib(nibName: "CategoryItemCollectionViewCell", bundle: .main),
            forCellWithReuseIdentifier: "CategoryItemCollectionViewCell"
        )
        
        moviesCollectionView.register(
            UINib(nibName: "MoviesCollectionView", bundle: .main),
            forCellWithReuseIdentifier: "MoviesCollectionView"
        )
    }
    private func setupCollectionViewDelegates() {
        categoriesListCollectionView.delegate = self
        categoriesListCollectionView.dataSource = self
        
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
    }
    private func bindViewModel() {
        ViewModel.$movies
            .receive(on: DispatchQueue.main)
            .removeDuplicates(by: { $0.map(\.id) == $1.map(\.id) })
            .sink { [weak self] moviesList in
                guard let self = self else { return }
                
                self.movies = moviesList
                self.moviesCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    func goToDetails(movieId: Int) {
        
        let vc = DetailsViewController(nibName: "DetailsViewController", bundle: nil)
        let vm = DetailsViewModel(movieId: movieId)
        vc.viewModel = vm
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - UICollectionView Delegate & DataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoriesListCollectionView {
            let selectedCategory = ViewModel.getCategory(at: indexPath.row)
            ViewModel.fetchMovies(for: selectedCategory)
        }

        if collectionView == moviesCollectionView {
            let selectedMovie = ViewModel.getMovie(at: indexPath.row)
            goToDetails(movieId: selectedMovie.id)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case categoriesListCollectionView:
            return ViewModel.getCategoriesCount()
        case moviesCollectionView:
            return ViewModel.getMovieCount()
        default:
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case categoriesListCollectionView:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "CategoryItemCollectionViewCell",
                for: indexPath
            ) as! CategoryItemCollectionViewCell
            cell.setupCell(with: ViewModel.getCategory(at: indexPath.row))
            return cell
            
        case moviesCollectionView:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "MoviesCollectionView",
                for: indexPath
            ) as! MoviesCollectionView
            cell.setUpMoiveCell(with: ViewModel.getMovie(at: indexPath.row))
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
}
extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchSubject.send(searchText)
    }
}


