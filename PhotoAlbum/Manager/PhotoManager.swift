//
//  PhotoManager.swift
//  PhotoAlbum
//
//  Created by 홍성준 on 2023/01/03.
//

import UIKit
import Photos

final class PhotoManager {
    
    static let shared = PhotoManager()
    
    private init() {}
    
    func requestImage(from imageView: UIImageView, for asset: PHAsset, size: CGSize, completion: ((UIImage?) -> Void)? = nil) {
        let identifier = String(describing: imageView)
        let requestID = PHCachingImageManager
            .default()
            .requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: nil) { image, _ in
                completion?(image)
            }
        
        self.requestIDs[identifier] = requestID
    }
    
    func cancelRequestImage(from imageView: UIImageView) {
        let identifier = String(describing: imageView)
        guard let requestID = self.requestIDs[identifier] else { return }
        PHCachingImageManager
            .default()
            .cancelImageRequest(requestID)
        self.requestIDs[identifier] = nil
    }
    
    func requestAuthorization(_ completion: ((Bool) -> Void)? = nil) {
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
    
    private var requestIDs: [String: PHImageRequestID] = [:]
    
}
