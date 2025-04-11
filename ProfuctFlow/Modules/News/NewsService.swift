//
//  NewsService.swift
//  ProfuctFlow
//
//  Created by Dima Kolesov on 11.04.2025.
//

import Foundation

protocol NewsServiceProtocol {
    func fetchNews(page: Int, itemsPerPage: Int) async throws -> NewsResponseDTO
    func fetchNewsDetail(id: Int) async throws -> NewsItemDTO
}

final class NewsService: NewsServiceProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchNews(page: Int, itemsPerPage: Int) async throws -> NewsResponseDTO {
        
        try await networkService.request(
            NewsEndpoint.getNews(page: page, itemsPerPage: itemsPerPage)
        )
    }
    
    func fetchNewsDetail(id: Int) async throws -> NewsItemDTO {
        try await networkService.request(
            NewsEndpoint.getNewsDetail(id: id)
        )
    }
}
