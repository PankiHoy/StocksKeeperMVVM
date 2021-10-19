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
    func fetchBags() -> [StocksBag]?
    func fetchBag(name: String) -> StocksBag?
    func add<T: NSManagedObject>(type: T.Type) -> T?
    func save()
    func delete<T: NSManagedObject>(object: T)
    func deleteAll<T: NSManagedObject>(object: T.Type)
}

final class BagViewModel: BagViewModelProtocol {
    public var updateViewData: ((ViewData) -> ())?
    private var networkService: NetworkServiceProtocol?
    private let coreDataManager: CoreDataManagerProtocol?
    
    init(_ networkService: NetworkServiceProtocol, _ coreDataManager: CoreDataManagerProtocol) {
        self.networkService = networkService
        self.coreDataManager = coreDataManager
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
