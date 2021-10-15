//
//  StockToBuy+CoreDataProperties.swift
//  StocksKeeperMVVM
//
//  Created by dev on 15.10.21.
//
//

import Foundation
import CoreData


extension StockToBuy {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StockToBuy> {
        return NSFetchRequest<StockToBuy>(entityName: "StockToBuy")
    }

    @NSManaged public var amount: Int64
    @NSManaged public var cost: Double
    @NSManaged public var day: String?
    @NSManaged public var dayBefore: String?
    @NSManaged public var name: String?
    @NSManaged public var symbol: String?
}

extension StockToBuy : Identifiable {

}
