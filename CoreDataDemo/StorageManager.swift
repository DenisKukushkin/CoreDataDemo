//
//  StorageManager.swift
//  CoreDataDemo
//
//  Created by Denis Kukushkin on 20.01.2023.
//

import Foundation
import CoreData


class StorageManager {

    static let shared = StorageManager()
        
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private init() {}
    
    //: MARK: - CoreData Methods
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchData(completion: ([Task]) -> Void) {
        let fetchRequest = Task.fetchRequest()

        do {
            let taskList = try context.fetch(fetchRequest)
            completion(taskList)
        } catch let error {
            print("Failed to fetch data", error)
        }
    }
    
    func save(_ taskName: String, completion: (Task) -> Void) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        guard let task = NSManagedObject(entity: entityDescription, insertInto: context) as? Task else { return }
        task.title = taskName
        
        completion(task)
        saveContext()
    }

    func edit(_ task: Task, updatedName: String) {
        task.title = updatedName
        saveContext()
        
    }
    
    func delete(_ task: Task) {
        context.delete(task)
        saveContext()
    }
}
