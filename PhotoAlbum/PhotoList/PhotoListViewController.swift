//
//  PhotoListViewController.swift
//  PhotoAlbum
//
//  Created by 홍성준 on 2023/01/03.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class PhotoListViewController: UIViewController {
    
    init(viewModel: PhotoListViewModel) {
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
        
        self.listView.do {
            $0.delegate = self
            $0.dataSource = self
        }
    }
    
    private func bind(_ viewModel: PhotoListViewModel) {
        viewModel.viewModelEvent
            .withUnretained(self)
            .subscribe(onNext: { viewController, event in viewController.handle(event) })
            .disposed(by: self.disposeBag)
        
        viewModel.title
            .withUnretained(self)
            .subscribe(onNext: { viewController, title in viewController.listView.updateTitle(title) })
            .disposed(by: self.disposeBag)
    }
    
    private func handle(_ event: PhotoListViewModelEvent) {
        switch event {
        case .reloadData:
            self.listView.reloadData()
            
        case .showAlert(let title, let message):
            self.showAlertController(title: title, message: message)
        }
    }
    
    private func showAlertController(title: String?, message: String?) {
        let action = UIAlertAction(
            title: "확인",
            style: .default
        )

        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        ).then {
            $0.addAction(action)
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    private let listView = PhotoListView(frame: .zero)
    private let viewModel: PhotoListViewModel
    private let disposeBag = DisposeBag()
    
}

extension PhotoListViewController: PhotoListViewDelegate {
    
    func navigationViewDidClickLeftButton(_ view: NavigationView) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.cellDidSelect(at: indexPath)
    }
    
}

extension PhotoListViewController: PhotoListViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.viewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfRowsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = self.viewModel.item(at: indexPath) else { return UICollectionViewCell() }
        switch item {
        case .photo(let model):
            guard let cell = collectionView.dequeueReusableCell(cell: PhotoListCollectionViewCell.self, for: indexPath) else {
                return UICollectionViewCell()
            }
            cell.configure(model)
            return cell
        }
    }
    
    
}
