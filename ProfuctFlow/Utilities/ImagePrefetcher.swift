//
//  ImagePrefetcher.swift
//  ProfuctFlow
//
//  Created by Dima Kolesov on 10.04.2025.
//

import UIKit

protocol ImagePrefetching: AnyObject {
    func prefetch(urls: [URL]) async
    func cancel(urls: [URL]) async
}

actor ImagePrefetcher: ImagePrefetching {
    private var activePrefetches: [URL: Task<Void, Never>] = [:]
    private var pendingUrls: [URL] = []
    private let maxConcurrentDownloads: Int
    private let imageService: ImageServiceProtocol
    
    init(maxConcurrentDownloads: Int = 4, imageService: ImageServiceProtocol = ImageCache.shared) {
        self.maxConcurrentDownloads = maxConcurrentDownloads
        self.imageService = imageService
    }
    
    func prefetch(urls: [URL]) {
        let newUrls = urls.filter { !pendingUrls.contains($0) && !activePrefetches.keys.contains($0) }
        pendingUrls.insert(contentsOf: newUrls, at: 0)
        processQueue()
    }
    
    func cancel(urls: [URL]) {
        for url in urls {
            activePrefetches[url]?.cancel()
            activePrefetches.removeValue(forKey: url)
            pendingUrls.removeAll { $0 == url }
        }
    }
    
    private func processQueue() {
        while activePrefetches.count < maxConcurrentDownloads && !pendingUrls.isEmpty {
            let url = pendingUrls.removeFirst()
            startDownload(for: url)
        }
    }
    
    private func startDownload(for url: URL) {
        guard activePrefetches[url] == nil else { return }
        
        activePrefetches[url] = Task { [weak self] in
            do {
                _ = try await self?.imageService.loadImage(for: url)
            } catch {
                print("Prefetch failed for \(url): \(error)")
            }
            await self?.handleDownloadCompletion(for: url)
        }
    }
    
    private func handleDownloadCompletion(for url: URL) {
        activePrefetches.removeValue(forKey: url)
        processQueue()
    }
}

