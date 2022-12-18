//
//  MovieReviews.swift
//  DisMo
//
//  Created by Jehnsen Hirena Kane on 18/12/22.
//

import Foundation

struct MovieReviewResponse: Decodable {
    let id: Int
    let results: [MovieReview]
    
    enum CodingKeys: String, CodingKey {
        case id, results
    }
     
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.results = try container.decodeIfPresent([MovieReview].self, forKey: .results) ?? []
    }
}

struct MovieReview: Decodable {
    let author: String
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case author, content
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.author = try container.decodeIfPresent(String.self, forKey: .author) ?? ""
        self.content = try container.decodeIfPresent(String.self, forKey: .content) ?? ""
    }
}
