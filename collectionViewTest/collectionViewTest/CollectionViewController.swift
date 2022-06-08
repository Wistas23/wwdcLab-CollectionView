//
//  CollectionViewController.swift
//  collectionViewTest
//
//  Created by Stanislav Klyushnik on 08.06.2022.
//

import UIKit

struct ViewModel: Hashable {
    let image: UIImage
    let name: String
    let type: SectionIdentifier
}

enum SectionIdentifier: Hashable {
    case horizontal, vertical
}

class CollectionViewController: UICollectionViewController {

    // MARK: Properties
    
    private var dataSource: UICollectionViewDiffableDataSource<SectionIdentifier, ViewModel>! = nil
    
    var hItems: [ViewModel] = {
        return Array(1...8).compactMap({ item in
            guard let image = UIImage(named: "bg\(item)") else { return nil }
            return ViewModel(image: image, name: "It`s #\(item)", type: .horizontal)
        })
    }()
    
    var vItems: [ViewModel] = {
        return Array(1...8).compactMap({ item in
            guard let image = UIImage(named: "bg\(item)") else { return nil }
            return ViewModel(image: image, name: "It`s #\(item)", type: .vertical)
        })
    }()
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Some CollectionView"
        collectionView.register(ColorCVC.self)
        collectionView.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableView.reuseIdentifier)
        createDataSource()
        createLayout()
        fillDataSource()
    }

    // MARK: UICollectionView DataSource

    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SectionIdentifier, ViewModel>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, item: ViewModel) -> UICollectionViewCell? in
            
            let cell: ColorCVC = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.model = item
            return cell
        }
        dataSource.supplementaryViewProvider = { [weak self] (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            guard let self = self else { return nil }
            switch kind {
                case UICollectionView.elementKindSectionHeader:
                    let section = self.dataSource.sectionIdentifier(for: indexPath.section)
                    switch section {
                        case .horizontal:
                            let header: HeaderReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderReusableView.reuseIdentifier, for: indexPath) as! HeaderReusableView
                            header.title = "Horizontal #\(indexPath.section)"
                            return header
                        case .vertical:
                            let header: HeaderReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderReusableView.reuseIdentifier, for: indexPath) as! HeaderReusableView
                            header.title = "Vertical #\(indexPath.section)"
                            return header
                        case .none:
                            return nil
                    }
                default:
                    return nil
            }
        }
    }

    private func fillDataSource() {
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([.horizontal])
        snapshot.appendItems(hItems, toSection: .horizontal)
        snapshot.appendSections([.vertical])
        snapshot.appendItems(vItems, toSection: .vertical)
        dataSource.apply(snapshot)
    }
    
    // MARK: UICollectionView Layout

    private func horizontalScroll(_ layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        let groupWidth = layoutEnvironment.container.contentSize.width * 0.3

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(groupWidth), heightDimension: .absolute(180))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)

        let sectionSideInset = (layoutEnvironment.container.contentSize.width - groupWidth) / 2
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: sectionSideInset, bottom: 16, trailing: sectionSideInset)

        section.orthogonalScrollingBehavior = .groupPaging

        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
            items.forEach { item in
                let distanceFromCenter = abs(item.frame.midX - offset.x - environment.container.contentSize.width / 2)
                let minScale: CGFloat = 0.8
                let maxScale: CGFloat = 1.0
                let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
                item.alpha = scale
            }
        }
        let totalWidth = layoutEnvironment.container.contentSize.width - 40
        let titleSize = NSCollectionLayoutSize(widthDimension: .absolute(totalWidth), heightDimension: .estimated(44))
        let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: titleSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
//        titleSupplementary.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [titleSupplementary]
        return section
    }
    
    private func listLayout() -> NSCollectionLayoutSection? {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(36))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(36))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20)
        let section = NSCollectionLayoutSection(group: group)
        
        let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
        let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: titleSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
//        titleSupplementary.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [titleSupplementary]
//        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 1000, trailing: 0)
        return section
    }
    
    private func createLayout() {
        let sectionProvider = { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            let section = self.dataSource.sectionIdentifier(for: sectionIndex)
            switch section {
                case .horizontal:
                    return self.horizontalScroll(layoutEnvironment)
                case .vertical:
                    return self.listLayout()
                case .none:
                    return nil
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        collectionView.collectionViewLayout = layout
    }
    
}
