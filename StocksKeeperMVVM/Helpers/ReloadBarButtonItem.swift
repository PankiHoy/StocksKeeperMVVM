//
//  ReloadBarButtonItem.swift
//  StocksKeeperMVVM
//
//  Created by dev on 22.10.21.
//

import UIKit

protocol ControllerWithReloadProtocol: AnyObject {
    func reloadViewData(sender: UIBarButtonItem)
}

class ReloadBarButtonItem: UIBarButtonItem {
    var delegate: ControllerWithReloadProtocol?
    
    override init() {
        super.init()
        self.image = UIImage(systemName: "arrow.clockwise")
        self.target = delegate
        self.action = #selector(reloadViewData(sender:))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func reloadViewData(sender: UIBarButtonItem) {
        delegate?.reloadViewData(sender: sender)
    }
}
