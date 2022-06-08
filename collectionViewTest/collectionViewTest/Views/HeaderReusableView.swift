//
//  HeaderReusableView.swift
//  collectionViewTest
//
//  Created by Stanislav Klyushnik on 08.06.2022.
//

import UIKit

class HeaderReusableView: UICollectionReusableView {

    static let reuseIdentifier: String = "HeaderReusableView"
    
    var titleLabel: UILabel = UILabel()
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configureCell() {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        addSubview(visualEffectView)
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            visualEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            visualEffectView.topAnchor.constraint(equalTo: topAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        visualEffectView.contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: visualEffectView.leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: visualEffectView.trailingAnchor, constant: -0),
            titleLabel.topAnchor.constraint(equalTo: visualEffectView.topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: visualEffectView.bottomAnchor, constant: -8)
        ])
        titleLabel.adjustsFontForContentSizeCategory = true
        let descriptor = UIFontDescriptor.preferredFontDescriptor(
            withTextStyle: .title3).addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.semibold]])
        titleLabel.font = UIFont(descriptor: descriptor, size: 0)
        
    }
    
}
