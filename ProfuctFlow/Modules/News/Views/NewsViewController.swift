//
//  NewsViewController.swift
//  ProfuctFlow
//
//  Created by Dima Kolesov on 14.04.2025.
//

import UIKit
import Combine

final class NewsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: NewsViewModel
    private let newsCollectionView: NewsCollectionView
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init(viewModel: NewsViewModel) {
        self.viewModel = viewModel
        self.newsCollectionView = NewsCollectionView()
        super.init(nibName: nil, bundle: nil)
        newsCollectionView.newsDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        loadInitialData()
    }
    
    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { [weak self] _ in
            self?.newsCollectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    // MARK: - Data Binding
    
    private func bindViewModel() {
        viewModel.$news
            .receive(on: DispatchQueue.main)
            .sink { [weak self] news in
                self?.handleNewsUpdate(news)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Data Loading
    
    private func loadInitialData() {
        Task {
            await viewModel.loadInitialContent()
        }
    }
    
    // MARK: - Update Handling
    
    private func handleNewsUpdate(_ news: [NewsItem]) {
        let viewModels = news.map { NewsCellViewModel(newsItem: $0) }
        newsCollectionView.updateData(with: viewModels)
    }
}

// MARK: - NewsCollectionDelegate

extension NewsViewController: NewsCollectionDelegate {
    
    func didSelectNews(_ newsItem: NewsItem) {
        guard let url = newsItem.articleUrl else { return }
        viewModel.coordinator?.showDetail(with: url)
    }
    
    func willDisplayItem(at indexPath: IndexPath) {
        guard indexPath.row >= viewModel.news.count - 2 else { return }
        Task {
            await viewModel.loadNextPageIfNeeded()
        }
    }
}

extension NewsViewController {
    
    func setupUI() {
        view.addSubview(newsCollectionView)
        newsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            newsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

