//
//  MainViewModel.swift
//  StocksKeeperMVVM
//
//  Created by dev on 8.10.21.
//

import Foundation
import CoreData

protocol BagViewModelProtocol {
    var updateViewData: ((ViewData)->())? {get set }
    func startFetch(withSymbol symbol: String)
    func fetchBags() -> [StocksBag]?
    func fetchBag(name: String) -> StocksBag?
    func add<T: NSManagedObject>(type: T.Type) -> T?
    func save()
    func delete<T: NSManagedObject>(object: T)
    func deleteAll<T: NSManagedObject>(object: T.Type)
}

final class BagViewModel: BagViewModelProtocol {
    public var updateViewData: ((ViewData) -> ())?
    private let networkService: NetworkServiceProtocol?
    private let coreDataManager: CoreDataManagerProtocol?
    
    init(_ networkService: NetworkServiceProtocol, _ coreDataManager: CoreDataManagerProtocol) {
        self.networkService = networkService
        self.coreDataManager = coreDataManager
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
    
    func fetchBags() -> [StocksBag]? {
        let bags = coreDataManager?.fetch(StocksBag.self)
        return bags
    }
    
    func fetchBag(name: String) -> StocksBag? {
        let bag = coreDataManager?.fetch(StocksBag.self, name)
        return bag
    }
    
    func add<T: NSManagedObject>(type: T.Type) -> T? {
        return coreDataManager?.add(type)
    }
    
    func save() {
        coreDataManager?.save()
    }
    
    func delete<T: NSManagedObject>(object: T) {
        coreDataManager?.delete(object: object)
    }
    
    func delete<T: NSManagedObject>(object: T.Type, key: String) {
        coreDataManager?.delete(object, key: key)
    }
    
    func deleteAll<T: NSManagedObject>(object: T.Type) {
        coreDataManager?.deleteAll(object)
    }
}
