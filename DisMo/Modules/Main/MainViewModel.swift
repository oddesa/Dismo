//
//  MainViewModel.swift
//  DisMo
//
//  Created by Macbook on 16/12/22.
//

import Foundation

final class MainViewModel {
    private let service: DismoServiceProtocol
    private var page = 1
    private var onFetching = false
    private var movieDetailCaches = [MovieDetailCache]()
//    var currentMovieDetail: MovieDetailCache?
    var total = 10
    var movies = [TrendingMovieDetail]()
    var onGetError: ((_ message: String?) -> Void)?
    var onFetchMoviesCompleted: ((_ newIndexPathsToReload: [IndexPath]?) -> Void)?
    var onGetMovieDetailCompleted: ((_ movieDetail: MovieDetail) -> Void)?
    
    init(service: DismoServiceProtocol) {
        self.service = service
    }
    
    func getTrendingMovies() {
        guard !onFetching else {
            self.onFetchMoviesCompleted?(.none)
            return
        }
        onFetching = true
        self.service.fetchTrendingMovies(page: page) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                self.total = response.totalResults
                self.onFetching = false
                self.page += 1
                self.movies.append(contentsOf: response.results)
                if self.page == 2 {
                    self.onFetchMoviesCompleted?(.none)
                } else {
                    let indexPathsToReload = self.calculateIndexPathsToReload(from: response.results)
                    self.onFetchMoviesCompleted?(indexPathsToReload)
                }
            case .failure(let error):
                self.onGetError?(error.localizedDescription)
            }
        }
    }
    
    private func calculateIndexPathsToReload(from newData: [TrendingMovieDetail]) -> [IndexPath] {
        let startIndex = movies.count - newData.count
        let endIndex = startIndex + newData.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    func getMovieDetails(id: Int) {
        if let cache = movieDetailCaches.first(where: {$0.id == id}) {
            self.onGetMovieDetailCompleted?(cache.movieDetail)
        } else {
            fetchMovieDetails(id: id)
        }
    }
    
    private func fetchMovieDetails(id: Int) {
        self.service.fetchMovieDetail(id: id) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                let newMovieDetail = MovieDetailCache(id: id, movieDetail: response)
                self.movieDetailCaches.append(newMovieDetail)
                self.onGetMovieDetailCompleted?(response)
            case .failure(let error):
                self.onGetError?(error.localizedDescription)
            }
        }
    }
}
