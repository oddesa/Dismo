//
//  CustomError.swift
//  DisMo
//
//  Created by Macbook on 16/12/22.
//

import Foundation

enum CustomError: Error, CustomNSError {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    
    var localizedDescription: String {
        switch self {
        case .apiError: return "Failed to fetch data"
        case .invalidEndpoint: return "Invalid endpoint"
        case .invalidResponse: return "Invalid response"
        case .noData: return "No data"
        case .serializationError: return "Failed to decode data"
        }
    }
    var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
}
