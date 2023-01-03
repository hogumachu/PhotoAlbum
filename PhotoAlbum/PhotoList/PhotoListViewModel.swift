//
//  PhotoListViewModel.swift
//  PhotoAlbum
//
//  Created by 홍성준 on 2023/01/03.
//

import Foundation
import Photos
import RxSwift
import RxRelay

enum PhotoListViewModelEvent {
    
    case reloadData
    case showAlert(title: String?, message: String?)
    
}

final class PhotoListViewModel {
    
    enum Section {
        case content([Item])
        
        var items: [Item] {
            switch self {
            case .content(let items):   return items
            }
        }
    }
    
    enum Item {
        case photo(PhotoListCollectionViewCellModel)
    }
    
    init(collection: PHAssetCollection) {
        self.collection = collection
        self.titleRelay.accept(collection.localizedTitle)
    }
    
    var title: Observable<String?> {
        self.titleRelay.asObservable()
    }
    
    var viewModelEvent: Observable<PhotoListViewModelEvent> {
        self.viewModelEventRelay.asObservable()
    }
    
    var numberOfSections: Int {
        self.sections.count
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return self.sections[safe: section]?.items.count ?? 0
    }
    
    func cellDidSelect(at indexPath: IndexPath) {
        guard let section = self.sections[safe: indexPath.section],
              let item = section.items[safe: indexPath.row]
        else {
            return
        }
        
        switch item {
        case .photo(let model):
            self.viewModelEventRelay.accept(.showAlert(
                title: "사진 정보",
                message: "파일명 : \(model.asset?.fileName ?? "")\n파일 크키 : \(model.asset?.size ?? "0 MB")"
            ))
        }
    }
    
    func item(at indexPath: IndexPath) -> Item? {
        guard let section = self.sections[safe: indexPath.section] else { return nil }
        return section.items[safe: indexPath.row]
    }
    
    func refresh() {
        self.fetchPhotoList()
    }
    
    private func fetchPhotoList() {
        PhotoRepository.shared.getPhotoList(collection: self.collection) { [weak self] photos in
            self?.performAfterFetchingPhotoList(photos: photos)
        }
    }
    
    private func performAfterFetchingPhotoList(photos: [Photo]) {
        self.sections = self.makeSections(photos: photos)
        self.viewModelEventRelay.accept(.reloadData)
    }
    
    private func makeSections(photos: [Photo]) -> [Section] {
        let items = photos.map { photo -> Item in
            return .photo(.init(asset: photo.asset))
        }
        
        return [.content(items)]
    }
    
    private let collection: PHAssetCollection
    private var sections: [Section] = []
    private let viewModelEventRelay = PublishRelay<PhotoListViewModelEvent>()
    private let titleRelay = BehaviorRelay<String?>(value: nil)
    
}
