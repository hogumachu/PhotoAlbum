//
//  UITableView+.swift
//  PhotoAlbum
//
//  Created by 홍성준 on 2023/01/03.
//

import UIKit

extension UITableView {
    
    func registerCell<T: UITableViewCell>(cell: T.Type) {
        self.register(cell, forCellReuseIdentifier: String(describing: cell))
    }
    
    func dequeueReusableCell<T: UITableViewCell>(cell: T.Type, for indexPath: IndexPath) -> T? {
        return self.dequeueReusableCell(withIdentifier: String(describing: cell), for: indexPath) as? T
    }
    
}
