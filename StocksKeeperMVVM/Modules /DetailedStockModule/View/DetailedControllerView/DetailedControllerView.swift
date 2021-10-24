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
    
    var company: DetailedViewData.CompanyOverview!//MARK: УБРАТЬ ЭТО И СДЕЛАТЬ ПО НОРМАЛЬНОМУ
    var delegate: DetailedStockViewController!
    
    lazy var contentView = makeContentView()
    lazy var activityIndicator = makeActivityIndicator()
    lazy var buyBlockView = makeBuyBlock()
    lazy var stackView: UIStackView? = UIStackView()
    
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
            let alertController = UIAlertController(title: "Requesting too soon", message: "Note: Thank you for using Alpha Vantage! Our standard API call frequency is 5 calls per minute and 500 calls per day. Please visit https://www.alphavantage.co/premium/ if you would like to target a higher API call frequency.", preferredStyle: .alert)
            addSubview(alertController.view)
            activityIndicator.stopAnimating()
        }
    }
    
    func update(viewData: DetailedViewData.CompanyOverview?, isHidden: Bool) {
        stackView?.removeFromSuperview()
        stackView = makeStackView(name: viewData?.name, symbol: viewData?.symbol, description: viewData?.description, day: viewData?.day, dayBefore: viewData?.dayBefore, bookmarked: viewData?.bookmarked)
        company = viewData
    }
}
