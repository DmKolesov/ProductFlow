//
//  NetworkError.swift
//  ProfuctFlow
//
//  Created by Dima Kolesov on 09.04.2025.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(Int, Data?)
    case noInternetConnection
    case timeout
    case unknown(Error?)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response"
        case .decodingError:
            return "Failed to decode response"
        case .serverError(let code, _):
            return "Server error: \(code)"
        case .noInternetConnection:
            return "No internet connection"
        case .timeout:
            return "Request timed out"
        case .unknown(let error):
            return error?.localizedDescription ?? "Unknown error"
        }
    }
}

