//
//  PhotoManager.swift
//  PhotoAlbum
//
//  Created by 홍성준 on 2023/01/03.
//

import UIKit
import Photos

final class PhotoManager {
    
    static func requestImage(for asset: PHAsset, size: CGSize, completion: ((UIImage?) -> Void)? = nil) {
        PHCachingImageManager
            .default()
            .requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: nil) { image, _ in
                completion?(image)
            }
    }
    
    static func requestAuthorization(_ completion: ((Bool) -> Void)? = nil) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            DispatchQueue.main.async {
                switch status {
                case .denied:
                    completion?(false)
                    
                default:
                    completion?(true)
                }
            }
        }
    }
    
}
