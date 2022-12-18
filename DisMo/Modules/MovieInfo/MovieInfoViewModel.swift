//
//  MovieInfoViewModel.swift
//  DisMo
//
//  Created by Jehnsen Hirena Kane on 17/12/22.
//

import Foundation
import RxSwift
import RxCocoa

final class MovieInfoViewModel {
    private let service: DismoServiceProtocol
    var error: BehaviorRelay<String> = BehaviorRelay(value: "")
    let movieDetail: MovieDetail
    let movieId: Int
    var trailersResponse: BehaviorRelay<MovieTrailerResponse?> = BehaviorRelay(value: nil)
    var reviewResponse: BehaviorRelay<MovieReviewResponse?> = BehaviorRelay(value: nil)
    
    init(service: DismoServiceProtocol, movieDetail: MovieDetail) {
        self.service = service
        self.movieId = movieDetail.id
        self.movieDetail = movieDetail
        getTrailers()
        getReviews()
    }
    
    private func getTrailers() {
        self.service.fetchTrailers(id: movieId) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                self.trailersResponse.accept(response)
            case .failure(let error):
                self.error.accept(error.localizedDescription)
            }
        }
    }
    
    func getReviews() {
        self.service.fetchReviews(id: movieId) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                self.reviewResponse.accept(response)
            case .failure(let error):
                self.error.accept(error.localizedDescription)
            }
        }
    }
}
