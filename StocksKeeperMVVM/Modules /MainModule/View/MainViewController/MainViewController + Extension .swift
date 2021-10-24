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
        title = "Favorites"
        view.backgroundColor = .white
        
        tabBarController?.tabBar.isHidden = false
        tabBarItem = UITabBarItem(title: "Favorites",
                                  image: UIImage(systemName: "star"),
                                  selectedImage: UIImage(systemName: "star.fill"))
    }
    
    func configureEffects() {
        bookmarkedStocksTableView.layer.cornerRadius = 20
        bookmarkedStocksTableView.clipsToBounds = true
        
        bookmarkedStocksTableView.layer.shadowColor = UIColor.black.cgColor
        bookmarkedStocksTableView.layer.shadowRadius = 2
        bookmarkedStocksTableView.layer.shadowOpacity = 0.3
        bookmarkedStocksTableView.layer.shadowOffset = CGSize(width: 2, height: 1)
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
            bookmarkedStocksTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            bookmarkedStocksTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            bookmarkedStocksTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ])
    }
}
