//
//  NewsMapper.swift
//  ProfuctFlow
//
//  Created by Dima Kolesov on 10.04.2025.
//

import Foundation

enum NewsMapper: DTOMapper {
    typealias Domain = NewsItem
    typealias DTO = NewsItemDTO
    
    static func mapToDomain(_ dto: NewsItemDTO) -> NewsItem {
        let imageUrl = URLValidator.validate(urlString: dto.titleImageUrl)
        let articleUrl = URLValidator.validate(urlString: dto.fullUrl)
        
        return NewsItem(
            id: UUID(),
            title: dto.title,
            description: dto.description,
            publishedDate: DateFormatter.newsDateFormatter.date(from: dto.publishedDate) ?? Date(),
            imageUrl: imageUrl,
            articleUrl: articleUrl,
            category: dto.categoryType
        )
    }
    
    static func mapToDTO(_ domain: NewsItem) -> NewsItemDTO {
        return NewsItemDTO(
            id: Int(domain.id.hashValue),
            title: domain.title,
            description: domain.description,
            publishedDate: DateFormatter.newsDateFormatter.string(from: domain.publishedDate),
            url: domain.articleUrl?.absoluteString ?? "",
            fullUrl: domain.articleUrl?.absoluteString ?? "",
            titleImageUrl: domain.imageUrl?.absoluteString ?? "",
            categoryType: domain.category
        )
    }
}

struct URLValidator {
    static func validate(urlString: String) -> URL? {
        guard let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encoded) else {
            return nil
        }
        return url
    }
}

