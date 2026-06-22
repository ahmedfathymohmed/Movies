//
//  WatchListCellViewController.swift
//  Movies
//
//  Created by Ahmed Fathy on 25/04/2026.
//

import UIKit

class WatchListViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var contanierView: UIView!
    @IBOutlet weak var moviesListView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var movieListTableView: UITableView!

    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var emptyDescriptionImageView: UIImageView!
    @IBOutlet weak var emptyDescriptionLabel: UILabel!
    @IBOutlet weak var emptyAdviceLabel: UILabel!
    
    var movies: [WatchListModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupUI()
        setUpEmptyView()
        backButton.setTitle("", for: .normal)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .white
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshMovies()
    }

    private func refreshMovies() {
        movies = WatchListStorage().getMovies()
        movieListTableView.reloadData()
        checkState()
    }
    func setupUI(){
        titleLabel.text = "Watch List"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        contanierView.backgroundColor  = UIColor(hex: "#242A32")
        emptyStateView.backgroundColor = UIColor(hex: "#242A32")
        moviesListView.backgroundColor = UIColor(hex: "#242A32")
        movieListTableView.backgroundColor = UIColor(hex: "#242A32")
    }
    func setupTableView(){
        movieListTableView.delegate = self
        movieListTableView.dataSource = self
        movieListTableView.separatorStyle = .none
        movieListTableView.register(UINib(nibName: "WatchListCellTableViewCell", bundle: nil),
        forCellReuseIdentifier: "WatchListCellTableViewCell")
    }
    func setUpEmptyView(){
        emptyDescriptionImageView.image = UIImage(named: "empty-file")
        emptyDescriptionLabel.text = "There is no movie yet!"
        emptyAdviceLabel.text = "Find your movie by Type title, categories, years, etc"
        emptyAdviceLabel.font = .systemFont(ofSize: 12)
        emptyAdviceLabel.textColor = UIColor(hex: "#92929D")
        emptyAdviceLabel.textColor = .white
        emptyDescriptionLabel.textColor = .white
    }
    func checkState() {
        let isEmpty = movies.isEmpty
        emptyStateView.isHidden = !isEmpty
        moviesListView.isHidden = isEmpty
    }
    
   

    @IBAction func backButton(_ sender: UIButton) {
        goToHomeTab()
    }
    @IBAction func emptyBackButton (_ sender: UIButton){
        goToHomeTab()
    }

    private func goToHomeTab() {
        if let mainTab = tabBarController as? MainTabBarController {
            mainTab.switchToTab(0)
        } else if navigationController?.viewControllers.first !== self {
            navigationController?.popViewController(animated: true)
        }
    }
}
extension WatchListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return  movies.count
    }
    func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "WatchListCellTableViewCell",
            for: indexPath
        ) as! WatchListCellTableViewCell
        let movie = movies[indexPath.row]
        cell.configure(movie: movie)
        return cell
    }
    func tableView(_ tableView: UITableView,trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) ->
        UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            guard let self = self else { completion(false); return }
            let movie = self.movies[indexPath.row]
            WatchListStorage().remove(movieId: movie.id)
            self.movies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.checkState()
            completion(true)
        }
        action.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}
