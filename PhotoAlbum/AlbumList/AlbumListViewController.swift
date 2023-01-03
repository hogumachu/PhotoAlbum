//
//  AlbumListViewController.swift
//  PhotoAlbum
//
//  Created by 홍성준 on 2023/01/03.
//

import UIKit
import SnapKit
import Then
import RxSwift
import Photos

final class AlbumListViewController: UIViewController {
    
    init(viewModel: AlbumListViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        self.setupListView()
        self.bind(viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.refresh()
    }
    
    private func setupListView() {
        self.view.addSubview(self.listView)
        self.listView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.listView.delegate = self
        self.listView.dataSource = self
    }
    
    private func bind(_ viewModel: AlbumListViewModel) {
        viewModel.viewModelEvent
            .withUnretained(self)
            .subscribe(onNext: { viewController, event in viewController.handle(event) })
            .disposed(by: self.disposeBag)
    }
    
    private func handle(_ event: AlbumListViewModelEvent) {
        switch event {
        case .reloadData:
            self.listView.reloadData()
            
        case .showAlert:
            self.showAlertController()
            
        case .showPhotoList(let collection):
            self.showPhotoList(collection: collection)
        }
    }
    
    private func showAlertController() {
        let settingAction = UIAlertAction(
            title: "이동",
            style: .default
        ) { action in
            self.openSettingApp()
        }

        let alertController = UIAlertController(
            title: "사진 권한이 없습니다.",
            message: "권한을 위해 설정으로 이동합니다.",
            preferredStyle: .alert
        ).then {
            $0.addAction(settingAction)
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func openSettingApp() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:])
    }
    
    private func showPhotoList(collection: PHAssetCollection) {
        let viewModel = PhotoListViewModel(collection: collection)
        let viewController = PhotoListViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private let listView = AlbumListView(frame: .zero)
    private let viewModel: AlbumListViewModel
    private let disposeBag = DisposeBag()
    
}

extension AlbumListViewController: AlbumListViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.viewModel.cellDidSelect(at: indexPath)
    }
    
}

extension AlbumListViewController: AlbumListViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = self.viewModel.item(at: indexPath) else { return UITableViewCell() }
        switch item {
        case .album(let model):
            guard let cell = tableView.dequeueReusableCell(cell: AlbumListTableViewCell.self, for: indexPath) else {
                return UITableViewCell()
            }
            cell.configure(model)
            return cell
        }
    }
    
}
