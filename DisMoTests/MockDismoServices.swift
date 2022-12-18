//
//  MockDismoServices.swift
//  DisMoTests
//
//  Created by Macbook on 19/12/22.
//

@testable import DisMo
import Foundation

class MockDismoServices: DismoServiceProtocol {
    var response: Any?
    
    func fetchTrendingMovies(page: Int, completion: @escaping (Result<DisMo.TrendingMovieResponse, DisMo.CustomError>) -> Void) {}
    
    func fetchMovieDetail(id: Int, completion: @escaping (Result<DisMo.MovieDetail, DisMo.CustomError>) -> Void) {}
    
    func fetchTrailers(id: Int, completion: @escaping (Result<DisMo.MovieTrailerResponse, DisMo.CustomError>) -> Void) {}
    
    func fetchReviews(id: Int, completion: @escaping (Result<DisMo.MovieReviewResponse, DisMo.CustomError>) -> Void) {
        if let json = response {
            let response = try! JSONDecoder().decode(MovieReviewResponse.self, withJSONObject: json)
            completion(.success(response))
        } else {
            completion(.failure(CustomError.apiError))
        }
    }
}

