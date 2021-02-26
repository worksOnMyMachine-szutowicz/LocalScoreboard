//
//  Storage.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 25/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import CoreData

protocol StorageInterface {
    var persistentContainer: NSPersistentContainer { get }
}

class Storage: StorageInterface {
    let persistentContainer: NSPersistentContainer
    
    private init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    private static var shared: StorageInterface?
    
    static func start(completion: @escaping (StorageInterface?) -> Void) {
        if let storage = shared {
            return completion(storage)
        }
        
        let container = NSPersistentContainer(name: "LocalScoreboard")
        container.loadPersistentStores(completionHandler: { _, error in
            if error != nil {
                completion(nil)
            }
            let storage = Storage(persistentContainer: container)
            completion(storage)
        })
    }
}
