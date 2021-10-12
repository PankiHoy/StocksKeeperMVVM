//
//  ContentView.swift
//  StocksKeeperMVVM
//
//  Created by dev on 8.10.21.
//

import UIKit

class SearchBar: UISearchBar {
    var viewData: ViewData = .initial {
        didSet {
            DispatchQueue.main.async {
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        }
    }
    
    var companies = [ViewData.CompaniesData.Company]()
    
    lazy var searchTableView = makeSearchTableView()
    lazy var activityIndicator = makeActivityIndicator()
    
    override func layoutSubviews() {
        switch viewData {
        case .initial:
            update(viewData: nil, isHidden: true)
            activityIndicator.stopAnimating()
        break
        case .loading(let loading):
            update(viewData: loading, isHidden: true)
            activityIndicator.startAnimating()
        case .success(let success):
            update(viewData: success, isHidden: false)
            activityIndicator.stopAnimating()
        case .failure(let failure):
            dump(failure)
            activityIndicator.stopAnimating()
        }
    }
    
    private func update(viewData: ViewData.CompaniesData?, isHidden: Bool) {
        companies = viewData?.companiesList ?? []
        searchTableView.isHidden = isHidden
        searchTableView.reloadData()
    }
}
