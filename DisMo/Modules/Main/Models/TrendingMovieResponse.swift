//
//  DiscoverMovieResponse.swift
//  DisMo
//
//  Created by Macbook on 16/12/22.
//

import Foundation

struct TrendingMovieResponse: Decodable {
    let page: Int
    let results: [TrendingMovieDetail]
    let totalResults: Int
    let totalPage: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalResults = "total_results"
        case totalPage = "total_pages"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.page = try container.decodeIfPresent(Int.self, forKey: .page) ?? 0
        self.results = try container.decodeIfPresent([TrendingMovieDetail].self, forKey: .results) ?? []
        self.totalResults = try container.decodeIfPresent(Int.self, forKey: .totalResults) ?? 0
        self.totalPage = try container.decodeIfPresent(Int.self, forKey: .totalPage) ?? 0
    }
}

struct TrendingMovieDetail: Decodable {
    let title: String
    let id: Int
    let rating: Float
    private let posterPath: String?
    
    var posterURL: URL? {
        guard let posterPath = posterPath else {
            return nil
        }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
    
    enum CodingKeys: String, CodingKey {
        case title, id
        case posterPath = "poster_path"
        case rating = "vote_average"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.rating = try container.decodeIfPresent(Float.self, forKey: .rating) ?? 0
    }
}
