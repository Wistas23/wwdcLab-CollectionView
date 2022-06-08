//
//  CollectionVeiwExt.swift
//  collectionViewTest
//
//  Created by Stanislav Klyushnik on 08.06.2022.
//

import UIKit

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_ cellClass: T.Type) {
        let className = String(describing: cellClass)
        let nib = UINib(nibName: className, bundle: nil)
        register(nib, forCellWithReuseIdentifier: className)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        let className = String(describing: T.classForCoder())
        return dequeueReusableCell(withReuseIdentifier: className, for: indexPath) as! T
    }

}
