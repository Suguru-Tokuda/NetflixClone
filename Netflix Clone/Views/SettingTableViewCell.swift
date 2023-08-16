//
//  SettingTableViewCell.swift
//  Netflix Clone
//
//  Created by Suguru on 10/27/22.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    static let identifier: String = "SettingTableViewCell"
    
    private let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let chevron: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(pointSize: 15))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(title)
        contentView.addSubview(chevron)
        
        applyConstraints()
    }
    
    private func applyConstraints() {
        let titleCostraints = [
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ]
        
        let chevronConstraints = [
            chevron.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            chevron.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(titleCostraints)
        NSLayoutConstraint.activate(chevronConstraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    public func configure(with title: String) {
        self.title.text = title
    }
}
