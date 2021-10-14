//
//  CoreDataManager.swift
//  StocksKeeperMVVM
//
//  Created by dev on 12.10.21.
//

import Foundation
import CoreData

class CoreDataManager {
    let persistentContainer: NSPersistentContainer
    static let shared = CoreDataManager()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func add <T: NSManagedObject>(_ type: T.Type) -> T? {
        guard let entityName = T.entity().name else { return nil }
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: viewContext) else { return nil }
        let record = T(entity: entity, insertInto: viewContext)
        return record
    }
    
    func fetch <T: NSManagedObject>(_ type: T.Type) -> [T]? {
        let request = T.fetchRequest()
        do {
            let result = try viewContext.fetch(request)
            return result as? [T]
        } catch {
            dump(error)
            return []
        }
    }
    
    func save() {
        do {
            try viewContext.save()
        } catch {
            viewContext.rollback()
            dump(error)
        }
    }
    
    func delete<T: NSManagedObject>(object: T) {
        viewContext.delete(object)
        save()
    }
    
    func delete(symbol: String?) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Stock")
        request.predicate = NSPredicate(format: "symbol == %@", symbol ?? "")
        do {
            let stockToRemove = try viewContext.fetch(request)
            viewContext.delete(stockToRemove.first as! NSManagedObject)
            try viewContext.save()
        } catch {
            print("stock can not be removed 'cause \(error.localizedDescription)")
        }
    }
    
    init() {
        persistentContainer = NSPersistentContainer(name: "StocksKeeperMVVM")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                dump(error)
            }
        }
        
    }
}
