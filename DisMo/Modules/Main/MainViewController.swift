//
//  ViewController.swift
//  DisMo
//
//  Created by Macbook on 16/12/22.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSourcePrefetching {
    @IBOutlet weak var movieTableView: UITableView!
    
    private lazy var indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var viewModel: MainViewModel = {
        let vm = MainViewModel(service: DismoServices())
        vm.onFetchMoviesCompleted = didFetchCompleted
        vm.onGetError = didGetError
        vm.onGetMovieDetailCompleted = didGetMovieDetailCompleted
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.title = "Trending movies"
        setupLayout()
        setupTableView()
        fetchInitialData()
    }
    
    private func fetchInitialData() {
        indicatorView.startAnimating()
        viewModel.getTrendingMovies()
    }
    
    private func didGetError(_ message: String?) -> Void {
        DispatchQueue.main.async { [weak self] in
            self?.indicatorView.stopAnimating()
            self?.popupAlert(title: "Error", message: message ?? "Error")
        }
    }
    
    private func didGetMovieDetailCompleted(_ movieDetail: MovieDetail) {
        DispatchQueue.main.async { [weak self] in
            self?.indicatorView.stopAnimating()
            let vm = MovieInfoViewModel(service: DismoServices(), movieDetail: movieDetail)
            let vc = MovieInfoViewController(viewModel: vm)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func setupLayout() {
        view.addSubview(indicatorView)
        NSLayoutConstraint.activate([
            indicatorView.topAnchor.constraint(equalTo: view.topAnchor),
            indicatorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            indicatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            indicatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    private func setupTableView() {
        movieTableView.delegate = self
        movieTableView.dataSource = self
        movieTableView.prefetchDataSource = self
        movieTableView.rowHeight = 110
        movieTableView.separatorStyle = .none
        movieTableView.showsVerticalScrollIndicator = false
        movieTableView.decelerationRate = .fast
        movieTableView.register(cellWithClass: MovieTableViewCell.self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.total
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: MovieTableViewCell.self)
        if isLoadingCell(for: indexPath) {
            cell.showLoadingView()
        } else {
            cell.setupContent(viewModel.movies[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indicatorView.startAnimating()
        viewModel.getMovieDetails(id: viewModel.movies[indexPath.row].id)
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.getTrendingMovies()
        }
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.movies.count
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = movieTableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
    
    func didFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            guard let newIndexPathsToReload = newIndexPathsToReload else {
                self.indicatorView.stopAnimating()
                self.movieTableView.isHidden = false
                self.movieTableView.reloadData()
                return
            }
            let indexPathsToReload = self.visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
            self.movieTableView.reloadRows(at: indexPathsToReload, with: .automatic)
        }
    }
}

