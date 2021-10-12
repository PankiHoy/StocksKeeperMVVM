//
//  Stock+CoreDataProperties.swift
//  StocksKeeperMVVM
//
//  Created by dev on 12.10.21.
//
//

import Foundation
import CoreData


extension Stock {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stock> {
        return NSFetchRequest<Stock>(entityName: "Stock")
    }

    @NSManaged public var name: String?
    @NSManaged public var symbol: String?
    @NSManaged public var desctiption: String?
    @NSManaged public var day: String?
    @NSManaged public var dayBefore: String?
    @NSManaged public var bookmarked: Bool

}

extension Stock : Identifiable {

}
