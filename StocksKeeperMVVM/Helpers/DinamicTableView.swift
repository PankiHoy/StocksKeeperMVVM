//
//  DinamicTableView.swift
//  StocksKeeperMVVM
//
//  Created by dev on 8.10.21.
//

import UIKit

class DinamicTableView: UITableView {

    private let maxHeight = UIScreen.main.bounds.height/2 - 100
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
    }
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        layoutIfNeeded()
    }
    
    override public var intrinsicContentSize: CGSize {
        setNeedsLayout()
        
        let height = min(contentSize.height, maxHeight) //MARK: СДЕЛАТЬ ПО НОРМАЛЬНОМУ ДЛЯ КЕЙСА ЕСЛИ ХОЧУ ОГРАНИЧИТЬ РАЗМЕР TableView
        
        return CGSize(width: contentSize.width, height: height)
    }

}
