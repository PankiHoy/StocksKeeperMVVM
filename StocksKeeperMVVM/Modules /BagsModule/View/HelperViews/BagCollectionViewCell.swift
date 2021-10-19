//
//  BagCollectionViewCell.swift
//  StocksKeeperMVVM
//
//  Created by dev on 16.10.21.
//

import UIKit

class BagCollectionViewCell: UICollectionViewCell {
    static let identifier = "bagCell"
    weak var delegate: BagViewController?
    
    var bagName: String?
    var cost: Double?
    
    lazy var gradientLayer: CAGradientLayer = {
        let gradLayer = CAGradientLayer()
        gradLayer.frame = bounds
        gradLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradLayer.locations = [0.7, 1.7]
        gradLayer.cornerRadius = 20
        
        return gradLayer
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 20
        
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.robotoItalic(withSize: 24)
        view.textColor = .white
        view.textAlignment = .center
        view.text = bagName
        
        return view
    }()
    
    lazy var costLabel: UILabel = {
        let costLabel = UILabel()
        costLabel.font = UIFont.robotoMedium(withSize: 20)
        costLabel.textColor = .white
        costLabel.textAlignment = .center
        costLabel.text = String(format: "%0.2f", cost ?? 0)
        
        return costLabel
    }()
    
    func configureCell() {
        backgroundColor = .lightLightGray
        configureCellShadow()
        configureLabels()
        //        configureAction()
    }
    
    private func configureLabels() {
        addSubview(nameLabel)
        addSubview(costLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        costLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            costLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            costLabel.heightAnchor.constraint(equalToConstant: 50),
            costLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
            nameLabel.heightAnchor.constraint(equalToConstant: 50),
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func configureAction() {
        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(removeBag(sender:))))
        isUserInteractionEnabled = true
    }
    
    private func configureCellShadow() {
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.addSublayer(gradientLayer)
        
        let cgPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: self.layer.cornerRadius, height: self.layer.cornerRadius)).cgPath
        layer.shadowPath = cgPath
        
        //        let layer1 = contentView.layer
        //        layer1.cornerRadius = 20
        //        layer1.shadowColor = UIColor.lightLightGray?.cgColor
        //        layer1.shadowOpacity = 1
        //        layer1.shadowRadius = 1.5
        //        layer1.shadowOffset = CGSize(width: -1, height: -1)
        //        let cgPath1 = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: self.layer.cornerRadius, height: self.layer.cornerRadius)).cgPath
        //        layer1.shadowPath = cgPath1
        //        layer1.masksToBounds = false
        //
        //        layer.insertSublayer(layer1, below: self.layer)
    }
    
    @objc private func removeBag(sender: UILongPressGestureRecognizer) {
        guard let cell = (sender.view as? BagCollectionViewCell) else { return}
        delegate?.removeBag(sender: cell)
    }
    
}
