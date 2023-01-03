//
//  Array+.swift
//  PhotoAlbum
//
//  Created by 홍성준 on 2023/01/03.
//

import Foundation

extension Array {
    
    subscript (safe index: Int) -> Element? {
        return self.indices ~= index ? self[index] : nil
    }
    
}
