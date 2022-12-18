//
//  NetworkingEndpoint.swift
//  DisMo
//
//  Created by Macbook on 16/12/22.
//

import Foundation

enum NetworkingMethod: String {
    case get, post, patch, put, delete
}

public enum NetworkingEndpoint {
    
    case getTrendingMovies
    case getMovieDetails(id: Int)
    case getMovieTrailers(id: Int)
    case getMovieReviews(id: Int)

    var value: String {
        switch self {
        case .getTrendingMovies: return "/3/trending/movie/week"
        case .getMovieDetails(let id): return "/3/movie/\(id)"
        case .getMovieTrailers(let id): return "/3/movie/\(id)/videos"
        case .getMovieReviews(let id): return "/3/movie/\(id)/reviews"
        }
    }
}
