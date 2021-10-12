//
//  MainViewModel.swift
//  StocksKeeperMVVM
//
//  Created by dev on 8.10.21.
//

import Foundation

protocol MainViewModelProtocol {
    var updateViewData: ((ViewData)->())? {get set }
    func startFetch(withSymbol: String)
}

final class MainViewModel: MainViewModelProtocol {
    public var updateViewData: ((ViewData) -> ())?
    private var networkService: NetworkServiceProtocol?
    
    init(_ networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    public func startFetch(withSymbol symbol: String) {
        updateViewData?(.loading(ViewData.CompaniesData(companiesList: nil)))
        networkService?.getCompaniesList(bySymbol: symbol, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let companiesList):
                self.updateViewData?(.success(ViewData.CompaniesData(companiesList: companiesList)))
            case .failure(let error):
                dump(error)
            }
        })
    }
    
    
}
