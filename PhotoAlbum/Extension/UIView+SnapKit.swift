//
//  UIView+SnapKit.swift
//  PhotoAlbum
//
//  Created by 홍성준 on 2023/01/03.
//

import UIKit
import SnapKit

extension UIView {
    
    var safeArea: ConstraintBasicAttributesDSL {
        return self.safeAreaLayoutGuide.snp
    }
    
}
