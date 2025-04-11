//
//  Paginator.swift
//  ProfuctFlow
//
//  Created by Dima Kolesov on 11.04.2025.
//

import Foundation

actor Paginator<T> {
    struct PageResult {
        let items: [T]
        let totalCount: Int
    }
    
    enum PaginatorState {
        case idle
        case loading
        case loaded
        case loadingNextPage
        case noMoreContent
        case error(Error)
    }
    
    private(set) var state: PaginatorState = .idle
    private var currentPage = 1
    private let itemsPerPage: Int
    private var hasMorePages = true
    private var totalItems = 0
    private var loadingPages: Set<Int> = []
    private var loadedPages: Set<Int> = []
    
    private let fetchPage: (Int, Int) async throws -> PageResult

    init(itemsPerPage: Int, fetchPage: @escaping (Int, Int) async throws -> PageResult) {
        self.itemsPerPage = itemsPerPage
        self.fetchPage = fetchPage
    }
    
    func reset() {
        currentPage = 1
        hasMorePages = true
        loadingPages.removeAll()
        loadedPages.removeAll()
        state = .idle
    }
    
    func loadNextPage() async throws -> [T] {
        guard hasMorePages, !loadingPages.contains(currentPage), !loadedPages.contains(currentPage) else {
            return []
        }

        state = currentPage == 1 ? .loading : .loadingNextPage
        loadingPages.insert(currentPage)

        do {
            defer { loadingPages.remove(currentPage) }
            let response = try await fetchPage(currentPage, itemsPerPage)
            totalItems = response.totalCount
            if response.items.isEmpty {
                hasMorePages = false
                state = .noMoreContent
            } else {
                hasMorePages = (currentPage * itemsPerPage) < totalItems
                loadedPages.insert(currentPage)
                currentPage += 1
                state = .loaded
            }
            return response.items
        } catch {
            state = .error(error)
            throw error
        }
    }
}

