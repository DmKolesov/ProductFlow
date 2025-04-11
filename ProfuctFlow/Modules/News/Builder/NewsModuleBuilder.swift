//
//  NewsModuleBuilder.swift
//  ProfuctFlow
//
//  Created by Dima Kolesov on 11.04.2025.
//

import Foundation

struct NewsModuleBuilder: ModuleBuilder {
    struct Input {
        let coordinator: NewsCoordinator
    }

    typealias Output = NewsViewController

    func build(with input: Input) -> NewsViewController {
        let newsService: NewsServiceProtocol = NewsService()
        let repository = NewsRepository(newsService: newsService)
        let imagePrefetcher: ImagePrefetching = ImagePrefetcher()
        let viewModel = NewsViewModel(
            repository: repository,
            imagePrefetcher: imagePrefetcher
        )
        viewModel.coordinator = input.coordinator
        return NewsViewController(viewModel: viewModel)
    }
}
