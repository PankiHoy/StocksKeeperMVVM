//
//  ModuleBuilder.swift
//  StocksKeeperMVVM
//
//  Created by dev on 8.10.21.
//

import Foundation
import UIKit

class ModuleBuilder {
    let networkService = NetworkService()
    let coreDataManager = CoreDataManager()
    
    func createMainModule() -> UIViewController {
        let view = MainViewController()
        let viewModel = MainViewModel(networkService, coreDataManager)
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
