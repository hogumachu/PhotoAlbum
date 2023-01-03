//
//  AlbumListTableViewCell.swift
//  PhotoAlbum
//
//  Created by 홍성준 on 2023/01/03.
//

import UIKit
import SnapKit
import Then
import Photos

struct AlbumListTableViewCellModel {
    
    let collection: PHAssetCollection
    let thumbnailAsset: PHAsset?
    let title: String?
    let imageCount: Int
    
}


final class AlbumListTableViewCell: UITableViewCell {
    
    private struct ViewConstraint {
        static let cellHeight: CGFloat = 85
        static let thumbnailSize: CGSize = .init(width: 70, height: 70)
        static let titleFont: UIFont = .systemFont(ofSize: 17)
        static let titleColor: UIColor? = .init(hex: "#000000")
        static let imageCountFont: UIFont = .systemFont(ofSize: 12)
        static let imageCountColor: UIColor? = .init(hex: "#000000")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupLayout()
        self.setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.titleLabel.text = nil
        self.imageCountLabel.text = nil
        self.thumbnailImageView.image = nil
    }
    
    func configure(_ model: AlbumListTableViewCellModel) {
        if let asset = model.thumbnailAsset {
            PhotoManager.requestImage(for: asset, size: ViewConstraint.thumbnailSize) { [weak self] image in
                self?.thumbnailImageView.image = image
            }
        }
        self.titleLabel.text = model.title
        self.imageCountLabel.text = "\(model.imageCount)"
    }
    
    private func setupLayout() {
        self.contentView.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(ViewConstraint.cellHeight)
        }
        
        self.containerView.addSubview(self.thumbnailImageView)
        self.thumbnailImageView.snp.makeConstraints { make in
            make.size.equalTo(ViewConstraint.thumbnailSize)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(5)
        }
        
        self.containerView.addSubview(self.labelStackView)
        self.labelStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.thumbnailImageView.snp.trailing).offset(10)
        }
        
        self.labelStackView.addArrangedSubview(self.titleLabel)
        self.labelStackView.addArrangedSubview(self.imageCountLabel)
    }
    
    private func setupAttributes() {
        self.containerView.do {
            $0.backgroundColor = .white
        }
        
        self.thumbnailImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
        
        self.labelStackView.do {
            $0.axis = .vertical
            $0.spacing = 5
        }
        
        self.titleLabel.do {
            $0.textColor = ViewConstraint.titleColor
            $0.font = ViewConstraint.titleFont
        }
        
        self.imageCountLabel.do {
            $0.textColor = ViewConstraint.imageCountColor
            $0.font = ViewConstraint.imageCountFont
        }
    }
    
    private let containerView = UIView(frame: .zero)
    private let thumbnailImageView = UIImageView(frame: .zero)
    private let labelStackView = UIStackView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let imageCountLabel = UILabel(frame: .zero)
    
}
