//
//  DismoServices.swift
//  DisMo
//
//  Created by Macbook on 16/12/22.
//

import Foundation

protocol DismoServiceProtocol {
    func fetchTrendingMovies(page: Int, completion: @escaping (Result<TrendingMovieResponse, CustomError>) -> Void)
    func fetchMovieDetail(id: Int, completion: @escaping (Result<MovieDetail, CustomError>) -> Void)
    func fetchTrailers(id: Int, completion: @escaping (Result<MovieTrailerResponse, CustomError>) -> Void)
    func fetchReviews(id: Int, completion: @escaping (Result<MovieReviewResponse, CustomError>) -> Void)
}

class DismoServices: DismoServiceProtocol {
    let defaultParams: [String:Any] = [
        "api_key": "5d33718a7f85a451830637377f4746d2"
    ]
    
    func fetchTrendingMovies(page: Int, completion: @escaping (Result<TrendingMovieResponse, CustomError>) -> Void) {
        var params = defaultParams
        params["page"] =  page
        
        NetworkingService.shared.request(.get,
                                         .getTrendingMovies,
                                         parameters: params,
                                         responseType: TrendingMovieResponse.self) { result in
            completion(result)
        }
    }
    
    func fetchMovieDetail(id: Int, completion: @escaping (Result<MovieDetail, CustomError>) -> Void) {
        NetworkingService.shared.request(.get,
                                         .getMovieDetails(id: id),
                                         parameters: defaultParams,
                                         responseType: MovieDetail.self) { result in
            completion(result)
        }
    }
    
    func fetchTrailers(id: Int, completion: @escaping (Result<MovieTrailerResponse, CustomError>) -> Void) {
        NetworkingService.shared.request(.get,
                                         .getMovieTrailers(id: id),
                                         parameters: defaultParams,
                                         responseType: MovieTrailerResponse.self) { result in
            completion(result)
        }
    }
    
    func fetchReviews(id: Int, completion: @escaping (Result<MovieReviewResponse, CustomError>) -> Void) {
        NetworkingService.shared.request(.get,
                                         .getMovieReviews(id: id),
                                         parameters: defaultParams,
                                         responseType: MovieReviewResponse.self) { result in
            completion(result)
        }
    }
}
