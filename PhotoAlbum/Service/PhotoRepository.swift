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
    
    func getAlbumList(completion: (([Album]) -> Void)? = nil)  {
        var albums: [Album] = []
        
        let options = PHFetchOptions().then {
            $0.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        }
        
        let defaultAlbum = PHAsset.fetchAssets(with: options)
        let defaultCollection = PHAssetCollection.transientAssetCollection(withAssetFetchResult: defaultAlbum, title: "최근 항목")
        albums.append(.init(
            collection: defaultCollection,
            thumbnailAsset: defaultAlbum.firstObject,
            title: "최근 항목",
            count: defaultAlbum.count
        ))
        
        let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        userCollections.enumerateObjects { userCollection, _, _ in
            let collection = userCollection as! PHAssetCollection
            albums.append(.init(
                collection: collection,
                thumbnailAsset: PHAsset.fetchAssets(in: collection, options: nil).firstObject,
                title: userCollection.localizedTitle,
                count: PHAsset.fetchAssets(in: userCollection as! PHAssetCollection, options: nil).count
            ))
        }
        DispatchQueue.main.async {
            completion?(albums)
        }
    }
    
    func getPhotoList(collection: PHAssetCollection, completion: (([Photo]) -> Void)? = nil) {
        var photos: [Photo] = []
        
        let options = PHFetchOptions().then {
            $0.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        }
        
        PHAsset.fetchAssets(in: collection, options: options)
            .enumerateObjects { asset, _, _ in
                photos.append(.init(asset: asset))
            }
        
        DispatchQueue.main.async {
            completion?(photos)
        }
    }
    
}

extension PhotoRepository: PHPhotoLibraryChangeObserver {
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        self.delegate?.photoRepositoryPhotoLibraryDidChange(self)
    }
    
}
