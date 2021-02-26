//
//  NSManagedObjectContext+CRUD.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 25/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import CoreData

extension NSManagedObjectContext {
    func createObject<T: NSManagedObject>() -> T {
        guard let object = NSEntityDescription.insertNewObject(forEntityName: T.className(), into: self) as? T else {
            fatalError("Incorrect object type")
        }
        
        return object
    }
    
    func saveChanges() -> NSError? {
        do {
            try save()
            return nil
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return error
        }
    }
    
    func fetchOrEmpty<T: NSManagedObject>(with fetchRequest: NSFetchRequest<T>) -> [T] {
        do {
            return try fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
}
