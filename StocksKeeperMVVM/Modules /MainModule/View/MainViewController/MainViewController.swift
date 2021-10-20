//
//  MainViewController.swift
//  StocksKeeperMVVM
//
//  Created by dev on 8.10.21.
//

import UIKit

class MainViewController: UIViewController {
    var viewModel: MainViewModelProtocol!
    
    lazy var searchBar = SearchBar()
    lazy var bookmarkedStocksTableView = BookmarkedStocksTableView.makeTableView()
    
    var bookmarks: [Stock]?
    
    lazy var bookmarksLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.robotoItalic(withSize: 24)
        label.text = "You will see your bookmarks here"
        label.numberOfLines = 0
        label.alpha = 0.5
        
        return label
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        configureTabBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchBookMarks()
        configureSearchBar()
        configureBookmarksTableView()
        configureBookmarsLabel(show: bookmarks?.isEmpty ?? true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        configureTabBar()
        configureSearchBar()
    }

    func updateView() {
        viewModel.updateViewData = { [weak self] viewData in
            self?.searchBar.viewData = viewData
        }
    }
    
    @objc func searchButtonTapped(sender: UIButton) {
        initiateSearch(true)
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.navigationItem.titleView = self?.searchBar
            self?.searchBar.showsCancelButton = true
            self?.searchBar.becomeFirstResponder()
            self?.navigationItem.rightBarButtonItem = nil
            self?.navigationItem.leftBarButtonItem = nil
        })
    }
    
    @objc func editBookmarks(sender: UIBarButtonItem) {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.bookmarkedStocksTableView.isEditing = true
            self?.navigationItem.leftBarButtonItem = nil
            self?.navigationItem.setLeftBarButton(UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self?.doneEditing(sender:))), animated: true)
        })
    }
    
    @objc func doneEditing(sender: UIBarButtonItem?) {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.bookmarkedStocksTableView.isEditing = false
            self?.navigationItem.leftBarButtonItem = nil
            self?.navigationItem.setLeftBarButton(UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(self?.editBookmarks(sender:))), animated: true)
        })
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
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                if let stockToRemove = self?.bookmarks?[indexPath.row] {
                    self?.viewModel.delete(object: stockToRemove)
                } //delete row
                self?.bookmarks = self?.viewModel.fetchBookmarks() //refetch data
                tableView.reloadData() //reload data
                
                if tableView.numberOfRows(inSection: 0) == 0 {
                    self?.configureBookmarsLabel(show: true)
                    self?.doneEditing(sender: nil)
                    self?.navigationItem.leftBarButtonItem?.isEnabled = false
                }
            })
        }
    }
    
    //MARK: - Selecting stock
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView === searchBar.searchTableView {
            let detailedController = (UIApplication.shared.delegate as! AppDelegate).router.createDetailedStockModule(withSymbol: searchBar.companies[indexPath.row].symbol ?? "AAPL")
            navigationController?.pushViewController(detailedController, animated: true)
        } else if tableView === bookmarkedStocksTableView {
            let detailedController = (UIApplication.shared.delegate as! AppDelegate).router.createDetailedStockModule(withSymbol: bookmarks?[indexPath.row].symbol ?? "AAPL")
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
            return bookmarks?.count ?? 0
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
            cell?.textLabel?.text = bookmarks?[indexPath.row].name
            cell?.detailTextLabel?.text = bookmarks?[indexPath.row].day
            cell?.detailTextLabel?.textColor = .black
            cell?.backgroundColor = .lightLightGray
            return cell!
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "cell")!
        }
    }
}

extension UIViewController {
    
}
