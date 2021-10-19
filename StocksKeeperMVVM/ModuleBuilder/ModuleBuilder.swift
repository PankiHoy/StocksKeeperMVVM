//
//  ModuleBuilder.swift
//  StocksKeeperMVVM
//
//  Created by dev on 8.10.21.
//

import Foundation
import UIKit

protocol ModuleBuilderProtocol {
    func createMainModule() -> UIViewController
    func createStocksBagModule(withBag bag: StocksBag) -> UIViewController
    func createDetailedStockModule(withSymbol symbol: String) -> UIViewController
}

class ModuleBuilder: ModuleBuilderProtocol {
    let networkService = NetworkService()
    let coreDataManager = CoreDataManager()
    
    func createMainModule() -> UIViewController {
        let view = MainViewController()
        let viewModel = MainViewModel(networkService, coreDataManager)
        view.viewModel = viewModel
        
        return view
    }
    
    func createBagsModule() -> UIViewController {
        let view = BagViewController()
        let viewModel = BagViewModel(networkService, coreDataManager)
        view.viewModel = viewModel
        
        return view
    }
    
    func createStocksBagModule(withBag bag: StocksBag) -> UIViewController {
        let view = StocksBagViewController(withBag: bag)
        let viewModel = StocksBagViewModel(networkService, coreDataManager)
        view.viewModel = viewModel
        
        return view
    }
    
    func createDetailedStockModule(withSymbol symbol: String) -> UIViewController {
        let view = DetailedStockViewController()
        let viewModel = DetailedStockViewModel(networkService, coreDataManager, symbol)
        view.viewModel = viewModel
        
        return view
    }
}
