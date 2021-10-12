//
//  MainViewModel.swift
//  StocksKeeperMVVM
//
//  Created by dev on 8.10.21.
//

import Foundation
import CoreData

protocol DetailedStockViewModelProtocol {
    var updateViewData: ((DetailedViewData)->())? {get set }
    func startFetch()
}

final class DetailedStockViewModel: DetailedStockViewModelProtocol {
    public var updateViewData: ((DetailedViewData) -> ())?
    private var networkService: NetworkServiceProtocol?
    private var coreDataManager: CoreDataManager?
    
    private var symbol: String!
    
    init(_ networkService: NetworkServiceProtocol, _ coreDataManager: CoreDataManager, _ symbol: String) {
        self.networkService = networkService
        self.coreDataManager = coreDataManager
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
    
    func add<T: NSManagedObject>(type: T.Type) -> T? {
        return coreDataManager?.add(type)
    }
    
    func save() {
        coreDataManager?.save()
    }
    
    func fetchBookmarks() {
        let bookmarks = coreDataManager?.fetch(Stock.self)
        dump(bookmarks)
    }
}
