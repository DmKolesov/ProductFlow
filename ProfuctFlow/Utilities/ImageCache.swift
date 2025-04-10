//
//  ImageCache.swift
//  ProfuctFlow
//
//  Created by Dima Kolesov on 10.04.2025.
//

import UIKit

protocol ImageServiceProtocol {
    func loadImage(for url: URL) async throws -> UIImage
}

// MARK: - ImageCache (Actor-based)
actor ImageCache: ImageServiceProtocol {
    static let shared = ImageCache()
    
    private let cache = NSCache<NSURL, UIImage>()
    private var loadingTasks: [URL: Task<UIImage, Error>] = [:]
    
    private init() {
        cache.countLimit = 200
        cache.totalCostLimit = 1024 * 1024 * 500 // 500 MB
    }
    
    func image(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }
    
    func setImage(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
    
    func loadImage(for url: URL) async throws -> UIImage {
        if let existingTask = loadingTasks[url] {
            return try await existingTask.value
        }
        
        if let cachedImage = image(for: url) {
            return cachedImage
        }
        
        let task = Task<UIImage, Error> {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {
                throw ImageError.invalidData
            }
            setImage(image, for: url)
            return image
        }
        
        loadingTasks[url] = task
        defer { loadingTasks.removeValue(forKey: url) }
        
        return try await task.value
    }
    
    func cancelLoading(for url: URL) {
        loadingTasks[url]?.cancel()
        loadingTasks.removeValue(forKey: url)
    }
    
    enum ImageError: Error {
        case invalidData
    }
}

