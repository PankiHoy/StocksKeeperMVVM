//
//  CoreDataManager.swift
//  StocksKeeperMVVM
//
//  Created by dev on 12.10.21.
//

import Foundation
import CoreData

protocol CoreDataManagerProtocol {
    var viewContext: NSManagedObjectContext { get }
    func add <T: NSManagedObject>(_ type: T.Type) -> T?
    func fetch <T: NSManagedObject>(_ type: T.Type) -> [T]?
    func fetch <T: NSManagedObject>(_ type: T.Type, _ key: String) -> T?
    func save()
    func delete<T: NSManagedObject>(object: T)
    func delete<T: NSManagedObject>(_ type: T.Type, symbol: String?)
    func delete<T: NSManagedObject>(_ type: T.Type, key: String?)
    func deleteAll<T: NSManagedObject>(_ type: T.Type)
}

class CoreDataManager: CoreDataManagerProtocol {
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
    
    func fetch <T: NSManagedObject>(_ type: T.Type, _ key: String) -> T? {
        guard let entityName = T.entity().name else { return nil }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.predicate = NSPredicate(format: "name == %@", key)
        do {
            let entities = try viewContext.fetch(request)
            if let entity = entities.first {
                return entity as? T
            }
        } catch {
            print("bag couldn't be founded, \(error.localizedDescription)")
        }
        return nil
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
    
    func delete<T: NSManagedObject>(_ type: T.Type, symbol: String?) {
        guard let entityName = T.entity().name else { return }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.predicate = NSPredicate(format: "symbol == %@", symbol ?? "")
        do {
            let stockToRemove = try viewContext.fetch(request)
            if let stockToRemove = stockToRemove.first {
                viewContext.delete(stockToRemove as! NSManagedObject)
            }
            try viewContext.save()
        } catch {
            print("stock can not be removed 'cause \(error.localizedDescription)")
        }
    }
    
    func delete<T: NSManagedObject>(_ type: T.Type, key: String?) {
        guard let entityName = T.entity().name else { return }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.predicate = NSPredicate(format: "symbol == %@", key ?? "")
        do {
            let bagToRemoveArray = try viewContext.fetch(request)
            if let bagToRemove = bagToRemoveArray.first {
                viewContext.delete(bagToRemove as! NSManagedObject)
            }
            try viewContext.save()
        } catch {
            print("stock can not be removed 'cause \(error.localizedDescription)")
        }
    }
    
    func deleteAll<T: NSManagedObject>(_ type: T.Type) {
        guard let entityName = T.entity().name else { return }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            let arraytoRemove = try viewContext.fetch(request)
            for obj in arraytoRemove {
                viewContext.delete(obj as! NSManagedObject)
            }
            try viewContext.save()
        } catch {
            print("object can not be removed 'cause \(error.localizedDescription)")
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
