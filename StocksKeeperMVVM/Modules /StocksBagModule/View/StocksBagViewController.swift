//
//  StocksBagViewController.swift
//  StocksKeeperMVVM
//
//  Created by dev on 14.10.21.
//

import UIKit

class StocksBagViewController: UIViewController {
    var viewModel: StocksBagViewModel!
//    var bag: StocksBag?
    
    let searchBar = SearchBar()
    
    lazy var stocksTableView: DinamicTableView = {
        let tableView = DinamicTableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.backgroundColor = .white
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        view.backgroundColor = .white
        
//        fetchBag() 
        configureTabBar()
        configureTableView()
    }
    
    func configureTabBar() {
        tabBarController?.tabBar.isHidden = false
        tabBarItem = UITabBarItem(title: "Your Stocks",
                                  image: UIImage(systemName: "bag"),
                                  selectedImage: UIImage(systemName: "bag.fill"))
        tabBarController?.tabBar.tintColor = .black
        navigationController?.navigationBar.tintColor = .black
        title = "Your Stocks"
    }
    
    func configureTableView() {
        stocksTableView.delegate = self
        stocksTableView.dataSource = self
        stocksTableView.register(UITableViewCell.self, forCellReuseIdentifier: "stocksCell")
        
        view.addSubview(stocksTableView)
        stocksTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stocksTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stocksTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stocksTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func initiateSearch(_ check: Bool) {
        if check {
            searchBar.searchTableView.delegate = self
            searchBar.searchTableView.dataSource = self
            
            searchBar.searchTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            
            searchBar.searchTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
            
            view.addSubview(searchBar.searchTableView)
            searchBar.searchTableView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                searchBar.searchTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                searchBar.searchTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                searchBar.searchTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
            ])
        } else {
            if view.subviews.contains(searchBar.searchTableView) {
                view.willRemoveSubview(searchBar.searchTableView)
                searchBar.searchTableView.removeFromSuperview()
                navigationItem.titleView = nil
            }
        }
    }
    
    func updateView() {
        viewModel.updateViewData = { [weak self] viewData in
            self?.searchBar.viewData = viewData
        }
    }
    
//    func fetchBag() {
//        if viewModel.fetchBag()?.count == 0 {
//            guard let stocksBag = viewModel.add(type: StocksBag.self) else { return }
//            stocksBag.stocks = []
//            viewModel.save()
//        }
//        bag = viewModel.fetchBag()?.first
//        stocksTableView.reloadData()
//    }
    
    @objc func searchButtonTapped(sender: UIButton) {
        initiateSearch(true)
        navigationItem.titleView = searchBar
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
        navigationItem.rightBarButtonItem = nil
        navigationItem.leftBarButtonItem = nil
    }
}

extension StocksBagViewController: UITableViewDelegate {
    
}

extension StocksBagViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0//return bag?.stocks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stocksCell")
//        cell?.textLabel?.text = (bag?.stocks as? [Stock]?)??.sorted(by: { $0.name! < $1.name! })[indexPath.row].name
        
        return cell!
    }
    
    
}
