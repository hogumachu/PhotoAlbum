//
//  AlbumListViewModel.swift
//  PhotoAlbum
//
//  Created by 홍성준 on 2023/01/03.
//

import Foundation
import RxSwift
import RxRelay

enum AlbumListViewModelEvent {
    
    case reloadData
    case showAlert
    
}

final class AlbumListViewModel {
    
    enum Section {
        case content([Item])
        
        var items: [Item] {
            switch self {
            case .content(let items):   return items
            }
        }
    }
    
    enum Item {
        case album(AlbumListTableViewCellModel)
    }
    
    var viewModelEvent: Observable<AlbumListViewModelEvent> {
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
        case .album(let model):
            // TODO: - Model
            print(model)
        }
    }
    
    func item(at indexPath: IndexPath) -> Item? {
        guard let section = self.sections[safe: indexPath.section] else { return nil }
        return section.items[safe: indexPath.row]
    }
    
    func refresh() {
        self.requestAuthorization()
    }
    
    private func requestAuthorization() {
        PhotoManager.requestAuthorization{ [weak self] authorized in
            if authorized {
                self?.fetchAlbumList()
            } else {
                self?.viewModelEventRelay.accept(.showAlert)
            }
        }
    }
    
    private func fetchAlbumList() {
        PhotoRepository.shared.getAlbumList { [weak self] albums in
            self?.performAfterFetchingAlbumList(albums: albums)
        }
    }
    
    private func performAfterFetchingAlbumList(albums: [Album]) {
        self.sections = self.makeSections(albums: albums)
        self.viewModelEventRelay.accept(.reloadData)
    }
    
    private func makeSections(albums: [Album]) -> [Section] {
        let items = albums
            .map { album -> Item in
                return .album(.init(thumbnailAsset: album.thumbnailAsset, title: album.title, imageCount: album.count))
            }
        return [.content(items)]
    }
    
    private var sections: [Section] = []
    private let viewModelEventRelay = PublishRelay<AlbumListViewModelEvent>()
    
}
