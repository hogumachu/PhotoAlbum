//
//  NavigationView.swift
//  PhotoAlbum
//
//  Created by 홍성준 on 2023/01/03.
//

import UIKit
import SnapKit
import Then

enum NavigationViewType {
    
    case none
    case back
    
}

extension NavigationViewType {
    
    var leftImage: UIImage? {
        switch self {
        case .none:
            return nil
            
        case .back:
            return UIImage(systemName: "chevron.backward")
        }
    }
}

protocol NavigationViewDelegate: AnyObject {
    
    func navigationViewDidClickLeftButton(_ view: NavigationView)
}

struct NavigationViewModel {
    
    let type: NavigationViewType
    let title: String?
    
    init(type: NavigationViewType, title: String?) {
        self.type = type
        self.title = title
    }
    
}

final class NavigationView: UIView {
    
    weak var delegate: NavigationViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupLayout()
        self.setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ model: NavigationViewModel) {
        self.leftButton.setImage(model.type.leftImage, for: .normal)
        self.titleLabel.text = model.title
    }
    
    func updateTitle(_ title: String?) {
        self.titleLabel.text = title
    }
    
    private func setupLayout() {
        self.addSubview(self.leftButton)
        self.leftButton.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(50)
        }
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(60)
        }
        
        self.addSubview(self.separator)
        self.separator.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    private func setupAttributes() {
        self.backgroundColor = .lightGray
        
        self.titleLabel.do {
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 17)
            $0.textAlignment = .center
        }
        
        self.leftButton.do {
            $0.tintColor = .black
            $0.contentMode = .center
            $0.addTarget(self, action: #selector(leftButtonClicked(_:)), for: .touchUpInside)
        }
        
        self.separator.do {
            $0.backgroundColor = .black.withAlphaComponent(0.05)
        }
    }
    
    @objc private func leftButtonClicked(_ sender: UIButton) {
        self.delegate?.navigationViewDidClickLeftButton(self)
    }
    
    private let titleLabel = UILabel(frame: .zero)
    private let leftButton = UIButton(frame: .zero)
    private let separator = UIView(frame: .zero)
    
}
