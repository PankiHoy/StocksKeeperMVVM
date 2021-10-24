//
//  MainViewModel.swift
//  StocksKeeperMVVM
//
//  Created by dev on 8.10.21.
//

import Foundation
import CoreData

protocol StocksbagViewModelPrototocol {
    var updateViewData: ((ViewData)->())? {get set }
    func fetchBag() -> [StocksBag]?
    func add<T: NSManagedObject>(type: T.Type) -> T?
    func save()
    func delete<T: NSManagedObject>(object: T)
    func deleteAll<T: NSManagedObject>(type: T.Type)
}

final class StocksBagViewModel: StocksbagViewModelPrototocol {
    public var updateViewData: ((ViewData) -> ())?
    private let networkService: NetworkServiceProtocol?
    private let coreDataManager: CoreDataManager?
    
    init(_ networkService: NetworkServiceProtocol, _ coreDataManager: CoreDataManager) {
        self.networkService = networkService
        self.coreDataManager = coreDataManager
    }
    
    func fetchBag() -> [StocksBag]? {
        let bag = coreDataManager?.fetch(StocksBag.self)
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
    
    func deleteAll<T: NSManagedObject>(type: T.Type) {
        coreDataManager?.deleteAll(type)
    }
}
