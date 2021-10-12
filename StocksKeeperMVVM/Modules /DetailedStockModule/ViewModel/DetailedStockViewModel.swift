//
//  MainViewModel.swift
//  StocksKeeperMVVM
//
//  Created by dev on 8.10.21.
//

import Foundation

protocol DetailedStockViewModelProtocol {
    var updateViewData: ((DetailedViewData)->())? {get set }
    func startFetch()
}

final class DetailedStockViewModel: DetailedStockViewModelProtocol {
    public var updateViewData: ((DetailedViewData) -> ())?
    private var networkService: NetworkServiceProtocol?
    
    private var symbol: String!
    
    init(_ networkService: NetworkServiceProtocol, _ symbol: String) {
        self.networkService = networkService
        self.symbol = symbol
    }
    
    public func startFetch() {
        updateViewData?(.loading(DetailedViewData.CompanyOverview(name: nil, symbol: nil, description: nil, day: nil, dayBefore: nil)))
        networkService?.getCompanyOverview(bySymbol: symbol, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let company):
                self.updateViewData?(.success(DetailedViewData.CompanyOverview(name: company?.name,
                                                                               symbol: company?.symbol,
                                                                               description: company?.description,
                                                                               day: company?.day,
                                                                               dayBefore: company?.dayBefore)))
            case .failure(let error):
                dump(error)
            }
        })
    }
    
    
}
