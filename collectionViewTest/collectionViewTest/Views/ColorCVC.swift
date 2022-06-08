//
//  ColorCVC.swift
//  collectionViewTest
//
//  Created by Stanislav Klyushnik on 08.06.2022.
//

import UIKit

class ColorCVC: UICollectionViewCell {
    
    @IBOutlet weak private var logoImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    
    var model: ViewModel? {
        didSet {
            guard let model else { return }
            logoImageView.image = model.image
            titleLabel.text = model.name
        }
    }
}
