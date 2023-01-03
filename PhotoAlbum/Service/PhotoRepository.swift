//
//  PhotoRepository.swift
//  PhotoAlbum
//
//  Created by 홍성준 on 2023/01/03.
//

import Photos
import Then

protocol PhotoRepositoryDelegate: AnyObject {
    
    func photoRepositoryPhotoLibraryDidChange(_ repository: PhotoRepository)
    
}

final class PhotoRepository: NSObject {
    static let shared = PhotoRepository()
    
    weak var delegate: PhotoRepositoryDelegate?
    
    override private init() {
        super.init()
        
        PHPhotoLibrary.shared().register(self)
    }
    
    func getAlbumList(_ completion: (([Album]) -> Void)? = nil)  {
        var albums: [Album] = []
        
        let options = PHFetchOptions().then {
            $0.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            $0.predicate = NSPredicate(format: "mediaType == \(PHAssetMediaType.image.rawValue)")
        }
        
        let defaultAlbum = PHAsset.fetchAssets(with: options)
        albums.append(.init(
            thumbnailAsset: defaultAlbum.firstObject,
            title: "최근 항목",
            count: defaultAlbum.count
        ))
        
        let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        userCollections.enumerateObjects { userCollection, _, _ in
            albums.append(.init(
                thumbnailAsset: PHAsset.fetchAssets(in: userCollection as! PHAssetCollection, options: nil).firstObject,
                title: userCollection.localizedTitle,
                count: PHAsset.fetchAssets(in: userCollection as! PHAssetCollection, options: nil).count
            ))
        }
        DispatchQueue.main.async {
            completion?(albums)
        }
    }
    
}

extension PhotoRepository: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        self.delegate?.photoRepositoryPhotoLibraryDidChange(self)
    }
}
