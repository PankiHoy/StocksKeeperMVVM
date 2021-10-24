//
//  StocksBag+CoreDataClass.swift
//  StocksKeeperMVVM
//
//  Created by dev on 15.10.21.
//
//

import Foundation
import CoreData

@objc(StocksBag)
public class StocksBag: NSManagedObject {
    
    func reloadProfit() {
        var allProfit: Double = 0
        
        for stock in stocksArray {
            allProfit += stock.currentAverageCost
        }
        
        profit = allProfit
    }

}
