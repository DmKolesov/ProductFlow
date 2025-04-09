//
//  NewsEndpoint.swift
//  ProfuctFlow
//
//  Created by Dima Kolesov on 09.04.2025.
//

import Foundation

enum NewsEndpoint: Endpoint {
    case getNews(page: Int, itemsPerPage: Int)
    case getNewsDetail(id: Int)
    
    var path: String {
        switch self {
        case .getNews(let page, let itemsPerPage):
            return "/news/\(page)/\(itemsPerPage)"
        case .getNewsDetail(let id):
            return "/news/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getNews, .getNewsDetail:
            return .get
        }
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
}

