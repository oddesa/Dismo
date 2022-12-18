//
//  MovieTrailer.swift
//  DisMo
//
//  Created by Jehnsen Hirena Kane on 17/12/22.
//

import Foundation

struct MovieTrailerResponse: Decodable {
    let id: Int
    let results: [MovieTrailerDetail]
    
    var officialTrailerKey:  String? {
        return results.first{$0.isOfficial}?.key ?? results.first?.key
    }
    
    enum CodingKeys: String, CodingKey {
        case id, results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.results = try container.decodeIfPresent([MovieTrailerDetail].self, forKey: .results) ?? []
    }
}

struct MovieTrailerDetail: Decodable {
    let id: String
    let key: String
    let isOfficial: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, key
        case isOfficial = "official"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        self.key = try container.decodeIfPresent(String.self, forKey: .key) ?? ""
        self.isOfficial = try container.decodeIfPresent(Bool.self, forKey: .isOfficial) ?? true
    }
}
