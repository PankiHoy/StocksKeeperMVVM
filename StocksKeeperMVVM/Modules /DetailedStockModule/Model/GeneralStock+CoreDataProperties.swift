//
//  GeneralStock+CoreDataProperties.swift
//  StocksKeeperMVVM
//
//  Created by dev on 20.10.21.
//
//

import Foundation
import CoreData


extension GeneralStock {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GeneralStock> {
        return NSFetchRequest<GeneralStock>(entityName: "GeneralStock")
    }

    @NSManaged public var latestCost: Double
    @NSManaged public var averageCost: Double
    @NSManaged public var name: String?
    @NSManaged public var subStocks: NSSet?
    
    public var subStocksArray: [StockToBuy] {
        let stocksSet = subStocks as? Set<StockToBuy> ?? []
        return stocksSet.sorted(by: { $0.name ?? "" < $1.name ?? "" })
    }
    
    public var currentAverageCost: Double {
        reloadAverageCost()
        return averageCost
    }
    
    public var currentLatestCost: Double {
        reloadLatestCost()
        return latestCost
    }

}

// MARK: Generated accessors for subStocks
extension GeneralStock {

    @objc(addSubStocksObject:)
    @NSManaged public func addToSubStocks(_ value: StockToBuy)

    @objc(removeSubStocksObject:)
    @NSManaged public func removeFromSubStocks(_ value: StockToBuy)

    @objc(addSubStocks:)
    @NSManaged public func addToSubStocks(_ values: NSSet)

    @objc(removeSubStocks:)
    @NSManaged public func removeFromSubStocks(_ values: NSSet)

}

extension GeneralStock : Identifiable {

}
