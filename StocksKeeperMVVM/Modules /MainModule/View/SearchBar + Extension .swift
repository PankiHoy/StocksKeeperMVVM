//
//  ContentView + Extension .swift
//  StocksKeeperMVVM
//
//  Created by dev on 8.10.21.
//

import Foundation
import UIKit

extension SearchBar {
    func makeActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .white
        activityIndicator.style = .medium
        
        activityIndicator.hidesWhenStopped = true
        
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalToSystemSpacingBelow: centerYAnchor, multiplier: 1),
            activityIndicator.trailingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1)
        ])
        
        return activityIndicator
    }
    
    func makeSearchTableView() -> UITableView {
        let tableView = DinamicTableView()
        tableView.layer.borderWidth = 0.1
        tableView.layer.borderColor = UIColor.black.cgColor
        
        return tableView
    }
}

