//
//  PhtoListCollectionViewCell.swift
//  PhotoAlbum
//
//  Created by 홍성준 on 2023/01/03.
//

import UIKit
import SnapKit
import Then
import Photos

struct PhotoListCollectionViewCellModel {
    
    let asset: PHAsset?
    
}

final class PhotoListCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupLayout()
        self.setupAtributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageView.image = nil
    }
    
    func configure(_ model: PhotoListCollectionViewCellModel) {
        guard let asset = model.asset else { return }
        PhotoManager.requestImage(for: asset, size: self.bounds.size) { [weak self] image in
            self?.imageView.image = image
        }
    }
    
    private func setupLayout() {
        self.contentView.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupAtributes() {
        self.imageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
    }
    
    private let imageView = UIImageView(frame: .zero)
    
}
