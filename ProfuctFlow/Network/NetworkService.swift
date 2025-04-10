//
//  NetworkService.swift
//  ProfuctFlow
//
//  Created by Dima Kolesov on 09.04.2025.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
    func request(_ endpoint: Endpoint) async throws
}

final class NetworkService: NetworkServiceProtocol {
    private let configuration: NetworkConfiguration
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(
        configuration: NetworkConfiguration = .default,
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.configuration = configuration
        self.session = session
        self.decoder = decoder
    }
    
    func request<T>(_ endpoint: Endpoint) async throws -> T where T : Decodable {
        let request = try createRequest(for: endpoint)
        let (data, response) = try await session.data(for: request)
        try validateResponse(response)
        
        do {
            let decodeResponse = try decoder.decode(T.self, from: data)
            return decodeResponse
        } catch {
            throw NetworkError.decodingError    
        }
    }
    
    func request(_ endpoint: Endpoint) async throws {
        let request = try createRequest(for: endpoint)
        let (_, response) = try await session.data(for: request)
        
        try validateResponse(response)
    }
    
    private func createRequest(for endpoint: Endpoint) throws -> URLRequest {
        var components = URLComponents(string: configuration.baseURL)
        components?.path += endpoint.path
        components?.queryItems = endpoint.queryItems
        
        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        
        configuration.defaultHeaders.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        endpoint.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
    
    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return
        default:
            throw NetworkError.serverError(httpResponse.statusCode, nil)
        }
    }
}
