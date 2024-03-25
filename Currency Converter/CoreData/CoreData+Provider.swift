//
//  CoreData+Provider.swift
//  Currency Converter
//
//  Created by Vahan Tsogolakyan on 24.03.24.
//

import CoreData

protocol IManagedObject: NSManagedObject {

}

protocol ICDConvertable {
    
    associatedtype ManagedModel: IManagedObject
    
    init(model: ManagedModel) throws
    
    @discardableResult
    func createManagedObject(context: NSManagedObjectContext) throws -> ManagedModel
}


extension NSManagedObject {
    
    class var entityName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

extension CoreData {
    
    class Provider {
        
        private let container: IDataBaseContainer
        
        init(container: IDataBaseContainer) {
            self.container = container
        }
    }
}

extension CoreData.Provider {
    
    func fetchCDModels<T: IManagedObject>(predicate: NSPredicate? = nil, context: NSManagedObjectContext? = nil, sort: [CoreData.Sort]? = nil) throws -> [T] {
        
        let context = context ?? self.container.viewContext
        return try context.performAndWait { () -> [T] in
            let fetchRequest = NSFetchRequest<T>(entityName: T.entityName)
            fetchRequest.includesSubentities = true
            fetchRequest.includesPropertyValues = true
            fetchRequest.predicate = predicate
            let sortDescriptors: [NSSortDescriptor]? = sort?.compactMap { (key) -> NSSortDescriptor in
                return NSSortDescriptor(key: key.key, ascending: key.ascending ?? false)
            }
            fetchRequest.sortDescriptors = sortDescriptors
            return try context.fetch(fetchRequest)
        }
    }
    
    func fetch<T: ICDConvertable>(predicate: NSPredicate? = nil, context: NSManagedObjectContext? = nil, sort: [CoreData.Sort]? = nil) throws -> [T] {
        let cdModels: [T.ManagedModel] = try self.fetchCDModels(predicate: predicate, context: context, sort: sort)
        return try cdModels.compactMap({ try T(model: $0) })
    }
    
    
}

extension CoreData.Provider {
    
    func save<T: ICDConvertable>(_ models: [T], context: NSManagedObjectContext? = nil) throws {
        let context = context ?? self.container.viewContext
        try context.performAndWait {
            try models.forEach({
                let cdModel = try $0.createManagedObject(context: context)
                context.insert(cdModel)
            })
            try context.save()
        }
    }
    
    func delateAll(entityName: String, predicate: NSPredicate? = nil, context: NSManagedObjectContext? = nil) throws {
        let context = context ?? self.container.viewContext
        try context.performAndWait {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
            fetchRequest.predicate = predicate
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try context.execute(deleteRequest)
            try context.save()
        }
    }
}
