//
//  PHAsset+.swift
//  PhotoAlbum
//
//  Created by 홍성준 on 2023/01/04.
//

import Photos

extension PHAsset {
    
    var fileName: String? {
        let resource = PHAssetResource.assetResources(for: self)
        return resource.first?.originalFilename
    }
    
    var size: String? {
        let bcf = ByteCountFormatter()
        let resources = PHAssetResource.assetResources(for: self)
        guard let resource = resources.first,
              let unsignedInt64 = resource.value(forKey: "fileSize") as? CLong else {
                  return nil
              }

        let sizeOnDisk = Int64(bitPattern: UInt64(unsignedInt64))
        bcf.allowedUnits = [.useMB]
        bcf.countStyle = .file
        return bcf.string(fromByteCount: sizeOnDisk)
    }
   
}
