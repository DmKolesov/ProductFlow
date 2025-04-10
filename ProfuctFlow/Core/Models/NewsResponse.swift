//
//  NewsResponse.swift
//  ProfuctFlow
//
//  Created by Dima Kolesov on 10.04.2025.
//

import Foundation

struct NewsResponse {
    let news: [NewsItem]
    let totalCount: Int
}

struct NewsItem: Identifiable, Hashable {
    let id: UUID
    let title: String
    let description: String
    let publishedDate: Date
    let imageUrl: URL?
    let articleUrl: URL?
    let category: String
        
    func hash(into hasher: inout Hasher) {
           hasher.combine(id.uuidString.hashValue)
       }
    static func == (lhs: NewsItem, rhs: NewsItem) -> Bool {
        lhs.id == rhs.id
    }
}

