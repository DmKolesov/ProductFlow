//
//  NewsRepository.swift
//  ProfuctFlow
//
//  Created by Dima Kolesov on 11.04.2025.
//

import Foundation

protocol NewsRepositoryProtocol {
    func fetchNews(page: Int, itemsPerPage: Int) async throws -> NewsResponse
    func fetchNewsDetail(id: Int) async throws -> NewsItem
}

final class NewsRepository: NewsRepositoryProtocol {
    private let newsService: NewsServiceProtocol
    
    
    init(newsService: NewsServiceProtocol) {
        self.newsService = newsService
    }
    
    func fetchNews(page: Int, itemsPerPage: Int) async throws -> NewsResponse {
   
        let responseDTO = try await newsService.fetchNews(
            page: page,
            itemsPerPage: itemsPerPage
        )

        return NewsResponseMapper.mapToDomain(responseDTO)
    }
    
    func fetchNewsDetail(id: Int) async throws -> NewsItem {
        let newsDTO = try await newsService.fetchNewsDetail(id: id)
        return NewsMapper.mapToDomain(newsDTO)
    }
}
