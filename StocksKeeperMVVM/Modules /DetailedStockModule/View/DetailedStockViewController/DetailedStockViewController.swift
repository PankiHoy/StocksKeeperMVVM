//
//  DetailedStockViewController.swift
//  StocksKeeperMVVM
//
//  Created by dev on 8.10.21.
//

import UIKit
import SnapKit

class DetailedStockViewController: UIViewController {
    var viewModel: DetailedStockViewModel?
    
    lazy var detailedView: DetailedControllerView = {
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

        view.addSubview(detailedView)
        detailedView.translatesAutoresizingMaskIntoConstraints = false
        
        detailedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        detailedView.delegate = self
        
        start()
        updateViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let reloadButton = ReloadBarButtonItem()
        reloadButton.delegate = self
        navigationItem.setRightBarButton(reloadButton, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func updateViews() {
        viewModel?.updateViewData = { [weak self] viewData in
            self?.detailedView.viewData = viewData
        }
    }
    
    private func start() {
        viewModel?.startFetch()
    }
}

extension DetailedStockViewController: ControllerWithReloadProtocol {
    func reloadViewData(sender: UIBarButtonItem) {
        viewModel?.fetchFromApi()
    }
}
