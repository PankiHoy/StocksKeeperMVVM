//
//  MainViewController.swift
//  StocksKeeperMVVM
//
//  Created by dev on 8.10.21.
//

import UIKit

class MainViewController: UIViewController {
    var viewModel: MainViewModelProtocol!
    private var searchBar = SearchBar()
    private var bookmarkedStocksTableView = BookmarkedStocksTableView()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
    
    func setup() {
        view.backgroundColor = .white
        configureTabBar()
        configureSearchBar()
    }
    
    func configureTabBar() {
        tabBarItem = UITabBarItem(title: "Favorites",
                                  image: UIImage(systemName: "star"),
                                  selectedImage: UIImage(systemName: "star.fill"))
        tabBarController?.tabBar.tintColor = .black
        navigationController?.navigationBar.tintColor = .black
        title = "Favorites"
    }

    func configureSearchBar() {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.delegate = self
        navigationItem.titleView = nil
        navigationItem.rightBarButtonItem = (UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                                                             style: .plain,
                                                             target: self,
                                                             action: #selector(searchButtonTapped(sender:))))
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
            }
        }
    }
    
    func updateView() {
        viewModel.updateViewData = { [weak self] viewData in
            self?.searchBar.viewData = viewData
        }
    }
    
    @objc func searchButtonTapped(sender: UIButton) {
        initiateSearch(true)
        navigationItem.titleView = searchBar
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
        navigationItem.rightBarButtonItem = nil
    }
}

//MARK: - SearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.startFetch(withSymbol: searchText)
        updateView()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        initiateSearch(false)
        configureSearchBar()
        searchBar.resignFirstResponder()
    }
}

//MARK: - TableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailedController = ModuleBuilder.createDetailedStockModule(withSymbol: searchBar.companies[indexPath.row].symbol ?? "AAPL")
        navigationController?.pushViewController(detailedController, animated: true)
    }
}

//MARK: - TableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchBar.companies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = searchBar.companies[indexPath.row].name
        
        return cell!
    }
}
