//
//  CoreData+DataBaseContainer.swift
//  Currency Converter
//
//  Created by Vahan Tsogolakyan on 24.03.24.
//

import CoreData

extension CoreData {
    
    class DataBaseContainer: IDataBaseContainer {
        
        let dbName: String
        
        var viewContext: NSManagedObjectContext {
            return self.persistentContainer.viewContext
        }
        
        lazy var backgroundContext: NSManagedObjectContext = {
            return self.persistentContainer.newBackgroundContext()
        }()
        
        init(with dbName: String) {
            self.dbName = dbName
        }
        
        // MARK: - Core Data stack

        lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: self.dbName)
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
                    
            return container
        }()

        // MARK: - Core Data Saving support

        func saveContext() {
            let context = self.persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
}

extension ApplicationError {
    
    enum CoreDataError: Int, Error {
        
        case dataNotExist
        
        var title: String {
            switch self {
            case .dataNotExist:
                return "Data not exist"
            }
        }
        
        var description: String {
            switch self {
            case .dataNotExist:
                return "Data not exist"
            }
        }
        
        var errorDomain: String {
            switch self {
            case .dataNotExist:
                return "Currency Converter"
            }
        }
    }
}
