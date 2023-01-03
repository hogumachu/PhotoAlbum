//
//  PhotoListView.swift
//  PhotoAlbum
//
//  Created by 홍성준 on 2023/01/03.
//

import UIKit
import SnapKit
import Then

typealias PhotoListViewDelegate = UICollectionViewDelegateFlowLayout & NavigationViewDelegate
typealias PhotoListViewDataSource = UICollectionViewDataSource

final class PhotoListView: UIView {
    
    weak var delegate: PhotoListViewDelegate? {
        didSet {
            self.collectionView.delegate = self.delegate
            self.navigationView.delegate = self.delegate
        }
    }
    
    weak var dataSource: PhotoListViewDataSource? {
        didSet { self.collectionView.dataSource = self.dataSource }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupLayout()
        self.setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        self.collectionView.reloadData()
    }
    
    func updateTitle(_ title: String?) {
        self.navigationView.updateTitle(title)
    }
    
    private func setupLayout() {
        self.addSubview(self.statusView)
        self.statusView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.safeArea.top)
        }
        
        self.addSubview(self.navigationView)
        self.navigationView.snp.makeConstraints { make in
            make.top.equalTo(self.statusView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        self.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        self.statusView.do {
            $0.backgroundColor = .lightGray
        }
        
        self.navigationView.do {
            $0.backgroundColor = .lightGray
            $0.configure(.init(type: .back, title: nil))
        }
        
        let flowLayout = UICollectionViewFlowLayout().then {
            $0.scrollDirection = .vertical
            let width: CGFloat = (UIScreen.width - 8) / 3
            $0.itemSize = CGSize(width: width, height: width)
            $0.minimumInteritemSpacing = 4
        }
        
        self.collectionView.do {
            $0.backgroundColor = .white
            $0.registerCell(cell: PhotoListCollectionViewCell.self)
            $0.collectionViewLayout = flowLayout
        }
    }
    
    private let statusView = UIView(frame: .zero)
    private let navigationView = NavigationView(frame: .zero)
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
}
