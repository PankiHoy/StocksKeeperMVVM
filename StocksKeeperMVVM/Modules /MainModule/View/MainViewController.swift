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
    private var bookmarkedStocksTableView = BookmarkedStocksTableView.makeTableView()
    
    var bookmarks: [Stock]!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchBookMarks()
        configureSearchBar()
        configureBookmarksTableView()
        configureBookmarsLabel(show: bookmarks.isEmpty)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        view.backgroundColor = .white
        configureTabBar()
    }
    
    func configureTabBar() {
        tabBarController?.tabBar.isHidden = false
        tabBarItem = UITabBarItem(title: "Favorites",
                                  image: UIImage(systemName: "star"),
                                  selectedImage: UIImage(systemName: "star.fill"))
        tabBarController?.tabBar.tintColor = .black
        navigationController?.navigationBar.tintColor = .black
        title = "Favorites"
    }
    
    func configureSearchBar() {
        initiateSearch(false)
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.delegate = self
        searchBar.sizeToFit()
        navigationItem.rightBarButtonItem = (UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                                                             style: .plain,
                                                             target: self,
                                                             action: #selector(searchButtonTapped(sender:))))
        navigationItem.setLeftBarButton(UIBarButtonItem(image: UIImage(systemName: "pencil"),
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(editBookmarks(sender:))), animated: true)
        
        if bookmarks.isEmpty {
            navigationItem.leftBarButtonItem?.isEnabled = false
        } else {
            navigationItem.leftBarButtonItem?.isEnabled = true
        }
    }
    
    func configureBookmarsLabel(show: Bool) {
        let bookmaksLabel = UILabel()
        if show {
            bookmaksLabel.font = UIFont.robotoItalic(withSize: 24)
            bookmaksLabel.text = "You will see your bookmarks here"
            bookmaksLabel.numberOfLines = 0
            bookmaksLabel.alpha = 0.5
            
            view.addSubview(bookmaksLabel)
            bookmaksLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                bookmaksLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                bookmaksLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        } else {
            if view.subviews.contains(bookmaksLabel) {
                bookmaksLabel.removeFromSuperview()
            }
        }
    }
    
    func configureBookmarksTableView() {
        bookmarkedStocksTableView.register(UITableViewCell.self, forCellReuseIdentifier: "bookMarkCell")
        bookmarkedStocksTableView.delegate = self
        bookmarkedStocksTableView.dataSource = self
        bookmarkedStocksTableView.isEditing = false
        
        view.addSubview(bookmarkedStocksTableView)
        bookmarkedStocksTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bookmarkedStocksTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bookmarkedStocksTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bookmarkedStocksTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
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
    
    @objc func searchButtonTapped(sender: UIButton) {
        initiateSearch(true)
        navigationItem.titleView = searchBar
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
        navigationItem.rightBarButtonItem = nil
        navigationItem.leftBarButtonItem = nil
    }
    
    @objc func editBookmarks(sender: UIBarButtonItem) {
        bookmarkedStocksTableView.isEditing = true
        navigationItem.leftBarButtonItem = nil
        navigationItem.setLeftBarButton(UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneEditing(sender:))), animated: true)
    }
    
    @objc func doneEditing(sender: UIBarButtonItem?) {
        bookmarkedStocksTableView.isEditing = false
        navigationItem.leftBarButtonItem = nil
        navigationItem.setLeftBarButton(UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(editBookmarks(sender:))), animated: true)
    }
    
    func fetchBookMarks() {
        bookmarks = viewModel.fetchBookmarks()
        bookmarkedStocksTableView.reloadData()
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
    //MARK: - Deleting Stock from Bookmarks
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let stockToRemove = bookmarks[indexPath.row]
            viewModel.delete(object: stockToRemove) //delete row
            bookmarks = viewModel.fetchBookmarks() //refetch data
            tableView.reloadData() //reload data
            
            if tableView.numberOfRows(inSection: 0) == 0 {
                configureBookmarsLabel(show: true)
                doneEditing(sender: nil)
                navigationItem.leftBarButtonItem?.isEnabled = false
            }
        }
    }
    
    //MARK: - Selecting stock
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView === searchBar.searchTableView {
            let detailedController = (UIApplication.shared.delegate as! AppDelegate).router.createDetailedStockModule(withSymbol: searchBar.companies[indexPath.row].symbol ?? "AAPL")
            navigationController?.pushViewController(detailedController, animated: true)
        } else if tableView === bookmarkedStocksTableView {
            let detailedController = (UIApplication.shared.delegate as! AppDelegate).router.createDetailedStockModule(withSymbol: bookmarks[indexPath.row].symbol ?? "AAPL")
            navigationController?.pushViewController(detailedController, animated: true)
        }
    }
}

//MARK: - TableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === searchBar.searchTableView {
            return searchBar.companies.count
        } else if tableView === bookmarkedStocksTableView {
            return bookmarks.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView === searchBar.searchTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            cell?.textLabel?.text = searchBar.companies[indexPath.row].name
            return cell!
        } else if tableView === bookmarkedStocksTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bookMarkCell")
            cell?.textLabel?.text = bookmarks[indexPath.row].name
            cell?.detailTextLabel?.text = bookmarks[indexPath.row].day
            cell?.detailTextLabel?.textColor = .black
            return cell!
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "cell")!
        }
    }
}

extension UIViewController {
    
}
