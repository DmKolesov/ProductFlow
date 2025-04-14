//
//  NewsCellViewModel.swift
//  ProfuctFlow
//
//  Created by Dima Kolesov on 11.04.2025.
//

import Foundation
import UIKit
import Combine

final class NewsCellViewModel: ObservableObject, Hashable {

    // MARK: - Properties
    
    let newsItem: NewsItem
    @Published var image: UIImage?
    @Published var isExpanded = false
    
    private let imageService: ImageServiceProtocol
    private var loadTask: Task<Void, Never>?

    // MARK: - Initialization
    
    init(
        newsItem: NewsItem,
        imageService: ImageServiceProtocol = ImageCache.shared
    ) {
        self.newsItem = newsItem
        self.imageService = imageService
        loadImage()
    }

    // MARK: - Hashable & Equatable
    
    static func == (lhs: NewsCellViewModel, rhs: NewsCellViewModel) -> Bool {
        lhs.newsItem.id == rhs.newsItem.id &&
        lhs.isExpanded == rhs.isExpanded &&
        lhs.image == rhs.image
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(newsItem.id)
        hasher.combine(isExpanded)
    }

    // MARK: - Image Loading
    
    func loadImage() {
        guard image == nil, let url = newsItem.imageUrl else { return }
        loadTask?.cancel()

        loadTask = Task { [weak self] in
            guard !Task.isCancelled, let self = self else { return }
            
            do {
                let loadedImage = try await self.imageService.loadImage(for: url)
                guard !Task.isCancelled else { return }
                
                await MainActor.run {
                    self.image = loadedImage
                }
            } catch {
                print("Image load failed: \(error.localizedDescription)")
            }
        }
    }
    
    func toggleExpansionState() {
        
    }

    // MARK: - Lifecycle Management
    
    func cancelLoading() {
        loadTask?.cancel()
        loadTask = nil
    }
    
    deinit {
        cancelLoading()
    }
}

