//
//  GeneralStock+CoreDataClass.swift
//  StocksKeeperMVVM
//
//  Created by dev on 20.10.21.
//
//

import Foundation
import CoreData


public class GeneralStock: NSManagedObject {

    func reloadAverageCost() {
        var allCost: Double = 0
        
        for stock in subStocksArray {
            allCost += stock.cost
        }
        
        averageCost = allCost
    }
    
    func reloadLatestCost() {
        
    }
    
}
