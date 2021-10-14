//
//  DetailedStockViewController.swift
//  StocksKeeperMVVM
//
//  Created by dev on 8.10.21.
//

import UIKit

class DetailedStockViewController: UIViewController {
    var viewModel: DetailedStockViewModel?
    
    lazy var testView: DetailedControllerView = {
        let detailedView = DetailedControllerView()
        
        return detailedView
    }()
    
    override func loadView() {
        super.loadView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .white
        self.tabBarController?.tabBar.isHidden = true

        view.addSubview(testView)
        testView.frame = view.bounds
        testView.delegate = self
        
        start()
        updateViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func updateViews() {
        viewModel?.updateViewData = { [weak self] viewData in
            self?.testView.viewData = viewData
        }
    }
    
    private func start() {
        viewModel?.startFetch()
    }

}
