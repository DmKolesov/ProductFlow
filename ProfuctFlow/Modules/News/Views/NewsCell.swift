//
//  NewsCell.swift
//  ProfuctFlow
//
//  Created by Dima Kolesov on 14.04.2025.
//

import UIKit
import Combine

protocol ExpandableNewsCellDelegate: AnyObject {
    func expandCell(cell: NewsCell)
    func collapseCell(cell: NewsCell)
}

enum ExpandableCellState {
    case collapsed, expanded
    
    var toggleTitle: String {
        switch self {
        case .collapsed: return "Показать больше"
        case .expanded: return "Свернуть"
        }
    }
}

final class NewsCell: UICollectionViewCell, ReusableView {
    
    weak var delegate: ExpandableNewsCellDelegate?
    private var viewModel: NewsCellViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    private var collapsedDescriptionHeight: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 120 : 80
    }
    private var collapsedDescriptionHeightConstraint: NSLayoutConstraint?
    
    private(set) var currentState: ExpandableCellState = .collapsed {
        didSet {
            updateCellState()
        }
    }

    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 1
        return label
    }()
    
    private let newsImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .darkGray
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 4
        return label
    }()
    
    private let toggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(ExpandableCellState.collapsed.toggleTitle, for: .normal)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleLabel, newsImageView, descriptionLabel, toggleButton])
        sv.axis = .vertical
        sv.spacing = 8
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        toggleButton.addTarget(self, action: #selector(toggleButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.cancelLoading()
        resetContent()
        currentState = .collapsed
    }

    // MARK: - Configure

    func configure(with viewModel: NewsCellViewModel) {
        self.viewModel?.cancelLoading()
        cancellables.removeAll()
        
        self.viewModel = viewModel
        
        resetContent()
        bindImage()
        
        titleLabel.text = viewModel.newsItem.title
        descriptionLabel.text = viewModel.newsItem.description
        
        currentState = viewModel.isExpanded ? .expanded : .collapsed
    }

    // MARK: - Private

    private func bindImage() {
        viewModel?.$image
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.newsImageView.image = image ?? UIImage(named: "placeholder")
            }
            .store(in: &cancellables)
    }

    private func resetContent() {
        newsImageView.image = nil
        cancellables.removeAll()
    }

    @objc private func toggleButtonTapped() {
        currentState = currentState == .collapsed ? .expanded : .collapsed
    }

    private func updateCellState() {
        toggleButton.setTitle(currentState.toggleTitle, for: .normal)
        switch currentState {
        case .expanded:
            expandCell()
        case .collapsed:
            collapseCell()
        }
    }
    
    private func expandCell(completion: (() -> Void)? = nil) {
        collapsedDescriptionHeightConstraint?.isActive = false
        descriptionLabel.numberOfLines = 0
        
        UIView.animate(withDuration: 0.3, animations: {
            self.stackView.layoutIfNeeded()
            self.layoutIfNeeded()
        }, completion: { _ in
            completion?()
        })
        
        delegate?.expandCell(cell: self)
    }
    
    private func collapseCell() {
        collapsedDescriptionHeightConstraint?.constant = collapsedDescriptionHeight
        collapsedDescriptionHeightConstraint?.isActive = true
        descriptionLabel.numberOfLines = 4
        
        UIView.animate(withDuration: 0.3) {
            self.contentView.layoutIfNeeded()
        }
        
        delegate?.collapseCell(cell: self)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        collapsedDescriptionHeightConstraint?.constant = collapsedDescriptionHeight
    }
}

// MARK: - UI Setup

private extension NewsCell {
    func setupUI() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
        
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        let aspectRatio: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 21/9 : 16/9
        newsImageView.heightAnchor.constraint(equalTo: newsImageView.widthAnchor, multiplier: 1/aspectRatio).isActive = true
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        collapsedDescriptionHeightConstraint = descriptionLabel.heightAnchor.constraint(equalToConstant: collapsedDescriptionHeight)
        collapsedDescriptionHeightConstraint?.priority = .defaultHigh
        collapsedDescriptionHeightConstraint?.isActive = true
        
        descriptionLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }
}

