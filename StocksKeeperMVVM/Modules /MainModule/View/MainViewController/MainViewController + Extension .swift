//
//  MainViewController + Extension .swift
//  StocksKeeperMVVM
//
//  Created by dev on 19.10.21.
//

import Foundation
import UIKit

extension MainViewController {
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
        
        if bookmarks?.isEmpty == true {
            navigationItem.leftBarButtonItem?.isEnabled = false
        } else {
            navigationItem.leftBarButtonItem?.isEnabled = true
        }
    }
    
    func configureBookmarsLabel(show: Bool) {
        if show {
            if !view.contains(bookmarksLabel) {
                view.addSubview(bookmarksLabel)
                bookmarksLabel.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    bookmarksLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    bookmarksLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
                ])
            }
        } else {
            if view.subviews.contains(bookmarksLabel) {
                bookmarksLabel.removeFromSuperview()
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
            bookmarkedStocksTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            bookmarkedStocksTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            bookmarkedStocksTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
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
                searchBar.searchTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                searchBar.searchTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
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
}
