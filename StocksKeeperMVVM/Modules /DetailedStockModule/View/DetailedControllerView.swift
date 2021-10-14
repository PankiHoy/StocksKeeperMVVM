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
    
    var company: DetailedViewData.CompanyOverview!// УБРАТЬ ЭТО НАХУЙ И СДЕЛАТЬ ПО НОРМАЛЬНОМУ
    var delegate: DetailedStockViewController!
    
    lazy var contentView = makeContentView()
    lazy var activityIndicator = makeActivityIndicator()
    var stackView: UIStackView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch viewData {
        case .initial:
            activityIndicator.startAnimating()
        case .loading(let loading):
            update(viewData: loading, isHidden: false)
            activityIndicator.stopAnimating()
        case .success(let success):
            update(viewData: success, isHidden: false)
            activityIndicator.stopAnimating()
        case .failure(let failure):
            update(viewData: failure, isHidden: false)
            activityIndicator.stopAnimating()
        }
    }
    
    func update(viewData: DetailedViewData.CompanyOverview?, isHidden: Bool) {
        stackView = nil
        stackView = makeStackView(name: viewData?.name, symbol: viewData?.symbol, description: viewData?.description, day: viewData?.day, dayBefore: viewData?.dayBefore, bookmarked: viewData?.bookmarked)
        company = viewData
    }
    
}
