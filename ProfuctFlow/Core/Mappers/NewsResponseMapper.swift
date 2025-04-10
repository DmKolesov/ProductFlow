//
//  NewsResponseMapper.swift
//  ProfuctFlow
//
//  Created by Dima Kolesov on 10.04.2025.
//

import Foundation

enum NewsResponseMapper: DTOMapper {
    typealias Domain = NewsResponse
    typealias DTO = NewsResponseDTO
    
    static func mapToDomain(_ dto: NewsResponseDTO) -> NewsResponse {
        return NewsResponse(
            news: dto.news.map(NewsMapper.mapToDomain),
            totalCount: dto.totalCount
        )
    }
    
    static func mapToDTO(_ domain: NewsResponse) -> NewsResponseDTO {
        return NewsResponseDTO(
            news: domain.news.map(NewsMapper.mapToDTO),
            totalCount: domain.totalCount
        )
    }
}
