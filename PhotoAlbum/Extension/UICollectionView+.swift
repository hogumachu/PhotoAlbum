//
//  UICollectionView+.swift
//  PhotoAlbum
//
//  Created by 홍성준 on 2023/01/03.
//

import UIKit

extension UICollectionView {
    
    func registerCell<T: UICollectionViewCell>(cell: T.Type) {
        self.register(cell, forCellWithReuseIdentifier: String(describing: cell))
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(cell: T.Type, for indexPath: IndexPath) -> T? {
        return self.dequeueReusableCell(withReuseIdentifier: String(describing: cell), for: indexPath) as? T
    }
    
}
