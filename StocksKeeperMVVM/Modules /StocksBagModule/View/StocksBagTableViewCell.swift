//
//  StocksBagTableViewCell.swift
//  StocksKeeperMVVM
//
//  Created by dev on 15.10.21.
//

import UIKit

class StocksBagTableViewCell: UITableViewCell {
    static let identifier = "stocksBagCell"
    
    lazy var costLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.robotoItalic(withSize: 10)
        label.textColor = .black
        
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.robotoMedium(withSize: 10)
        label.textColor = .black
        
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.robotoMedium(withSize: 10)
        label.textColor = .black
        
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell() {
        backgroundColor = .lightLightGray
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(amountLabel)
        stackView.addArrangedSubview(costLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        costLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            costLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
        ])
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}
