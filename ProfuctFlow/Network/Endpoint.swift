//
//  Endpoint.swift
//  ProfuctFlow
//
//  Created by Dima Kolesov on 09.04.2025.
//

import Foundation

protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
}

extension Endpoint {
    var queryItems: [URLQueryItem]? { nil }
    var headers: [String: String]? { nil }
    var body: Data? { nil }
}
