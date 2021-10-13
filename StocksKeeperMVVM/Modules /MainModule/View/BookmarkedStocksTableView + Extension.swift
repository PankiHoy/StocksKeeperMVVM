//
//  BookmarkedStocksTableView.swift
//  StocksKeeperMVVM
//
//  Created by dev on 12.10.21.
//

import UIKit

extension BookmarkedStocksTableView {

    static func makeTableView() -> UITableView {
        let tableView = DinamicTableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        return tableView
    }

}
