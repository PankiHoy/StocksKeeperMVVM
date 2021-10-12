//
//  MKStackView.swift
//  StocksKeeperMVVM
//
//  Created by dev on 8.10.21.
//

import UIKit

class DetailedControllerView: UIView {
    var viewData: DetailedViewData = .initial {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.setNeedsLayout()
                self?.layoutIfNeeded()
            }
        }
    }
    
    lazy var contentView = makeContentView()
    lazy var activityIndicator = makeActivityIndicator()
    lazy var stackView = makeStackView(name: nil, symbol: nil, description: nil, day: nil, dayBefore: nil, bookmarked: nil)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch viewData {
        case .initial:
            activityIndicator.startAnimating()
        case .loading(let loading):
            update(viewData: loading, isHidden: false)
            activityIndicator.startAnimating()
        case .success(let success):
            update(viewData: success, isHidden: false)
            activityIndicator.stopAnimating()
        case .failure(let failure):
            update(viewData: failure, isHidden: false)
            activityIndicator.stopAnimating()
        }
    }
    
    func update(viewData: DetailedViewData.CompanyOverview?, isHidden: Bool) {
        stackView = makeStackView(name: viewData?.name, symbol: viewData?.symbol, description: viewData?.description, day: viewData?.day, dayBefore: viewData?.dayBefore, bookmarked: true)
    }
    
}
