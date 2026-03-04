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
    private let ViewModel = HomeViewModel()
    weak var coordinator: AppCoordinator?
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
            return CGSize(width: 100, height: 25)
        }
        
        let spacing: CGFloat = 3
        let numberOfItemsPerRow: CGFloat = 2
        let totalSpacing = spacing * (numberOfItemsPerRow + 1)
        
        let width = (collectionView.frame.width - totalSpacing) / numberOfItemsPerRow
        let height = width * 1.5
        
        return CGSize(width: width, height: height)
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Watch New Movies"
        titleLabel.textColor = .yellow
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        registerCollectionViewCells()
        setupCollectionViewDelegates()
        setupMoviesCollectionViewLayout()
        bindViewModel()
        ViewModel.fetchMovies(endpoint: .popular)
        
    }
    
    private func setupMoviesCollectionViewLayout() {
        if let layout = moviesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 3
            layout.minimumLineSpacing = 10
            layout.sectionInset = .zero
        }
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
            .sink { [weak self] moviesList in
                self?.movies = moviesList
                self?.moviesCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        ViewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { error in
                if let error = error {
                    print("Error: \(error)")
                }
            }
            .store(in: &cancellables)
    }
}
extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        ViewModel.filterMovies(text: searchText)
        moviesCollectionView.reloadData()
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
            coordinator?.goToDetails(movieId: selectedMovie.id)
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



