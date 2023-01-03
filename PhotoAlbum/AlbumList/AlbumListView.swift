//
//  AlbumListView.swift
//  PhotoAlbum
//
//  Created by 홍성준 on 2023/01/03.
//

import UIKit
import SnapKit
import Then

typealias AlbumListViewDelegate = UITableViewDelegate
typealias AlbumListViewDataSource = UITableViewDataSource

final class AlbumListView: UIView {
    
    weak var delegate: AlbumListViewDelegate? {
        didSet { self.tableView.delegate = self.delegate }
    }
    
    weak var dataSource: AlbumListViewDataSource? {
        didSet { self.tableView.dataSource = self.dataSource }
    }
    
    private struct ViewConstraint {
        static let navigationColor = UIColor(hex: "EDEDED")
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
        self.tableView.reloadData()
    }
    
    private func setupLayout() {
        self.addSubview(self.statusView)
        self.statusView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.safeArea.top)
        }
        
        self.addSubview(self.navigationView)
        self.navigationView.snp.makeConstraints { make in
            make.top.equalTo(self.safeArea.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        self.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        self.statusView.backgroundColor = ViewConstraint.navigationColor
        
        self.navigationView.do {
            $0.backgroundColor = ViewConstraint.navigationColor
            $0.configure(.init(type: .none, title: "앨범"))
        }
        
        self.tableView.do {
            $0.backgroundColor = .white
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
            $0.registerCell(cell: AlbumListTableViewCell.self)
            $0.tableHeaderView = UIView().then({
                $0.frame = CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude)
            })
        }
    }
    
    private let statusView = UIView(frame: .zero)
    private let navigationView = NavigationView(frame: .zero)
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
}
