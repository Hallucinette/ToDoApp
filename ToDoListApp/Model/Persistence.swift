//
//  Persistence.swift
//  ToDoListApp
//
//  Created by Amelie Pocchiolo on 04/01/2023.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for index in 0..<10 {
                // add preview
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        //Creatinf the entity
        let taskEntity = NSEntityDescription()
        taskEntity.name = "TaskList"
        taskEntity.managedObjectClassName = "TaskList"
        
        // now creating the attribute
        let idAttribute = NSAttributeDescription()
        idAttribute.name = "id"
        idAttribute.type = .uuid
        taskEntity.properties.append(idAttribute)
        
        let nameAttribute = NSAttributeDescription()
        nameAttribute.name = "name"
        nameAttribute.type = .string
        taskEntity.properties.append(nameAttribute)
        
        let completeAdttribute = NSAttributeDescription()
        completeAdttribute.name = "complete"
        completeAdttribute.type = .boolean
        taskEntity.properties.append(completeAdttribute)
        
        let priorityNumAttribute = NSAttributeDescription()
        priorityNumAttribute.name = "priorityNum"
        priorityNumAttribute.type = .integer32
        taskEntity.properties.append(priorityNumAttribute)
        
        let dateAttribute = NSAttributeDescription()
        dateAttribute.name = "date"
        dateAttribute.type = .date
        taskEntity.properties.append(dateAttribute)
        
        let alarmAttribute = NSAttributeDescription()
        alarmAttribute.name = "alarm"
        alarmAttribute.type = .date
        taskEntity.properties.append(alarmAttribute)
        
        let orderAttribute = NSAttributeDescription()
        orderAttribute.name = "order"
        orderAttribute.type = .integer64
        taskEntity.properties.append(orderAttribute)

        
        // now let's creat Core Data model
        
        let model = NSManagedObjectModel()
        model.entities = [taskEntity]
        
        container = NSPersistentContainer(name: "ToDoList", managedObjectModel: model)
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
