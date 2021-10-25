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
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        searchTableView.dataSource = self
        searchTableView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        searchTableView.dataSource = self
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

extension SearchBar: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        companies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = companies[indexPath.row].name
        return cell!
    }
}

extension SearchBar: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailedController = (UIApplication.shared.delegate as! AppDelegate).router.createDetailedStockModule(withSymbol: companies[indexPath.row].symbol ?? "AAPL")
        (delegate as? UIViewController)?.navigationController?.pushViewController(detailedController, animated: true)
    }
}
