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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(testView)
        testView.frame = view.bounds
        testView.delegate = self
        
        start()
        updateViews()
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
