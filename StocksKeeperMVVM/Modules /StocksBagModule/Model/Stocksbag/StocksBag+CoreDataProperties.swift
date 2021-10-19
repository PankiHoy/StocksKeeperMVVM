//
//  StocksBag+CoreDataProperties.swift
//  StocksKeeperMVVM
//
//  Created by dev on 15.10.21.
//
//

import Foundation
import CoreData


extension StocksBag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StocksBag> {
        return NSFetchRequest<StocksBag>(entityName: "StocksBag")
    }

    @NSManaged public var name: String?
    @NSManaged public var profit: Double
    @NSManaged public var stocks: NSSet?
    
    public var stocksArray: [StockToBuy] {
        let stocksSet = stocks as? Set<StockToBuy> ?? []
        return stocksSet.sorted(by: { $0.name ?? "" < $1.name ?? "" })
    }

}

// MARK: Generated accessors for stocks
extension StocksBag {

    @objc(addStocksObject:)
    @NSManaged public func addToStocks(_ value: StockToBuy)

    @objc(removeStocksObject:)
    @NSManaged public func removeFromStocks(_ value: StockToBuy)

    @objc(addStocks:)
    @NSManaged public func addToStocks(_ values: NSSet)

    @objc(removeStocks:)
    @NSManaged public func removeFromStocks(_ values: NSSet)

}

extension StocksBag : Identifiable {

}
