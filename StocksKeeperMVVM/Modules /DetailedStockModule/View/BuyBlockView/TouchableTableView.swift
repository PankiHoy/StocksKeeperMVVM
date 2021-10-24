//
//  TouchableTableView.swift
//  StocksKeeperMVVM
//
//  Created by dev on 22.10.21.
//

import UIKit

class TouchableTableView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
