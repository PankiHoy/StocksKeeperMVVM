//
//  ColorCollectionViewCell.swift
//  StocksKeeperMVVM
//
//  Created by dev on 26.10.21.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    
    func configureCell(withColor color: UIColor) {
        let subview = UIView(frame: CGRect(x: 8, y: 8, width: 24, height: 24))
        subview.layer.cornerRadius = 6
        subview.backgroundColor = color
        
        layer.cornerRadius = 10
        layer.shadowRadius = 2
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        backgroundColor = .white
        
        addSubview(subview)
    }
    
}
