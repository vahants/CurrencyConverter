//
//  CoreData.swift
//  Currency Converter
//
//  Created by Vahan Tsogolakyan on 24.03.24.
//

import CoreData

protocol IDataBaseContainer {
    
    var viewContext: NSManagedObjectContext { get }
    var backgroundContext: NSManagedObjectContext { get }
    
}

class CoreData {
    
    static let shared: CoreData = CoreData()
    
    private let container: DataBaseContainer
    let provider: Provider
    
    private init() {
        container = .init(with: "Currency")
        provider = .init(container: container)
    }
     
}

extension CoreData {
    
    struct Sort {
        
        public let key: String
        public let ascending: Bool?
        
        public init(key: String, ascending: Bool? = nil) {
            self.key = key
            self.ascending = ascending
        }
        
        public func create(key: String, ascending: Bool? = nil) -> Sort {
            return Sort(key: key, ascending: ascending)
        }
    }
}
