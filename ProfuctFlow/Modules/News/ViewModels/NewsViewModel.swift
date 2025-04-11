//
//  NewsViewModel.swift
//  ProfuctFlow
//
//  Created by Dima Kolesov on 11.04.2025.
//

import Foundation
import Combine

final class NewsViewModel: ObservableObject {
    
    // MARK: - Published State
    @Published private(set) var state: Paginator<NewsItem>.PaginatorState = .idle
    @Published private(set) var news: [NewsItem] = []
    @Published private(set) var isLoadingMore = false
    
    // MARK: - Dependencies
    private let paginator: Paginator<NewsItem>
    private let repository: NewsRepositoryProtocol
    private let imagePrefetcher: ImagePrefetching
    weak var coordinator: NewsCoordinator?
    
    // MARK: - Initialization
    init(repository: NewsRepositoryProtocol,
         imagePrefetcher: ImagePrefetching) {
        self.repository = repository
        self.imagePrefetcher = imagePrefetcher
        self.paginator = Paginator<NewsItem>(
            itemsPerPage: 15,
            fetchPage: { [repository] page, itemsPerPage in
                let response = try await repository.fetchNews(
                    page: page,
                    itemsPerPage: itemsPerPage
                )
                return Paginator.PageResult(
                    items: response.news,
                    totalCount: response.totalCount
                )
            }
        )
    }
}

// MARK: - Public Interface
extension NewsViewModel {
    @MainActor
    func loadInitialContent() async {
        await paginator.reset()
        do {
            news = try await paginator.loadNextPage()
            state = await paginator.state
        } catch {
            state = .error(error)
        }
    }
    
    @MainActor
    func loadNextPageIfNeeded() async {
        guard case .loaded = state else { return }
        
        isLoadingMore = true
        do {
            let newItems = try await paginator.loadNextPage()
            news.append(contentsOf: newItems)
            
            let urls = newItems.compactMap { $0.imageUrl }
            await imagePrefetcher.prefetch(urls: urls)
            
            state = await paginator.state
        } catch {
            state = .error(error)
        }
        isLoadingMore = false
    }
}
