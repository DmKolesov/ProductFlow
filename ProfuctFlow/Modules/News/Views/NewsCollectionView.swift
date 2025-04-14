//
//  NewsCollectionView.swift
//  ProfuctFlow
//
//  Created by Dima Kolesov on 14.04.2025.
//

import UIKit

// MARK: - NewsCollectionDelegate Protocol

protocol NewsCollectionDelegate: AnyObject {
    func didSelectNews(_ newsItem: NewsItem)
    func willDisplayItem(at indexPath: IndexPath)
}

// MARK: - News Collection View

final class NewsCollectionView: UICollectionView {
    
    // MARK: - Properties
    
    weak var newsDelegate: NewsCollectionDelegate?
    private var diffableDataSource: DataSource!
    
    // MARK: - DataSource Types
    
    private enum Section: Hashable {
        case main
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, NewsCellViewModel>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, NewsCellViewModel>
    
    // MARK: - Initialization
    
    init() {
        super.init(
            frame: .zero,
            collectionViewLayout: NewsCollectionLayoutProvider.makeLayout()
        )
        configureCollectionView()
        setupDataSource()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configuration

private extension NewsCollectionView {
    func configureCollectionView() {
        backgroundColor = .systemBackground
        delegate = self
        register(NewsCell.self)
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func setupDataSource() {
        diffableDataSource = DataSource(
            collectionView: self,
            cellProvider: { [weak self] collectionView, indexPath, viewModel in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: NewsCell.reuseIdentifier,
                    for: indexPath
                ) as! NewsCell
                cell.configure(with: viewModel)
                cell.delegate = self
                return cell
            }
        )
    }
}

// MARK: - Data Management

extension NewsCollectionView {
    func updateData(with viewModels: [NewsCellViewModel]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModels)
        
        DispatchQueue.main.async { [weak self] in
            self?.diffableDataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

// MARK: - UICollectionViewDelegate

extension NewsCollectionView: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        newsDelegate?.willDisplayItem(at: indexPath)
    }
    
    func collectionView(
            _ collectionView: UICollectionView,
            didSelectItemAt indexPath: IndexPath
        ) {
            guard let viewModel = diffableDataSource.itemIdentifier(for: indexPath) else { return }
            newsDelegate?.didSelectNews(viewModel.newsItem)
        }
}

// MARK: - Expandable Cell Delegate

extension NewsCollectionView: ExpandableNewsCellDelegate {
    func expandCell(cell: NewsCell) {
        performCellStateUpdate(for: cell, isExpanded: true)
    }
    
    func collapseCell(cell: NewsCell) {
        performCellStateUpdate(for: cell, isExpanded: false)
    }
    
    private func performCellStateUpdate(for cell: NewsCell, isExpanded: Bool) {
        guard let indexPath = indexPath(for: cell),
              let viewModel = diffableDataSource.itemIdentifier(for: indexPath)
        else { return }
        
        var snapshot = diffableDataSource.snapshot()
        viewModel.isExpanded = isExpanded
        snapshot.reloadItems([viewModel])
        
        DispatchQueue.main.async { [weak self] in
            self?.diffableDataSource.apply(snapshot, animatingDifferences: false) {
                self?.layoutIfNeeded()
            }
        }
    }
}

