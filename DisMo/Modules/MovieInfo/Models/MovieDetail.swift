//
//  MovieDetail.swift
//  DisMo
//
//  Created by Macbook on 16/12/22.
//

import Foundation

struct MovieDetail: Decodable {
    let id: Int
    let overview: String
    let releaseDate: String
    let title: String
    let rating: Float
    let voteCount: Int
    private let posterPath: String?
    
    var posterURL: URL? {
        guard let posterPath = posterPath else {
            return nil
        }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
    
    enum CodingKeys: String, CodingKey {
        case id, overview,title
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case rating = "vote_average"
        case voteCount = "vote_count"
    }
    
    init() {
        self.id = 0
        self.overview = ""
        self.releaseDate = ""
        self.title = ""
        self.rating = 0
        self.voteCount = 0
        self.posterPath = nil
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview) ?? ""
        self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath) ?? ""
        self.releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate) ?? ""
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.rating = try container.decodeIfPresent(Float.self, forKey: .rating) ?? 0
        self.voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount) ?? 0
    }
}
