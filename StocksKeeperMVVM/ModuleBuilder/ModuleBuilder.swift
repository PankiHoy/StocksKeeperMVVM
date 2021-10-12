//
//  ModuleBuilder.swift
//  StocksKeeperMVVM
//
//  Created by dev on 8.10.21.
//

import Foundation
import UIKit

class ModuleBuilder {
    static func createMainModule() -> UIViewController {
        let view = MainViewController()
        let networkService = NetworkService()
        let viewModel = MainViewModel(networkService)
        view.viewModel = viewModel
        
        return view
    }
    
    static func createDetailedStockModule(withSymbol symbol: String) -> UIViewController {
        let view = DetailedStockViewController()
        let networkService = NetworkService()
        let viewModel = DetailedStockViewModel(networkService, symbol)
        view.viewModel = viewModel
        
        return view
    }
}
