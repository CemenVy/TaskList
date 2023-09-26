//
//  StorageManager.swift
//  TaskList
//
//  Created by Семен Выдрин on 26.09.2023.
//

import UIKit
import CoreData

final class StorageManager {
    static let shared = StorageManager()
    
    private init() {}
    
    func fetchData() -> [TodoTask] {
        let fetchRequest: NSFetchRequest<TodoTask> = TodoTask.fetchRequest()
        
        do {
            let tasks = try persistentContainer.viewContext.fetch(fetchRequest)
            return tasks
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func save(task title: String) {
        let task = TodoTask(context: persistentContainer.viewContext)
        task.title = title
        saveContext()
    }
    
    func deletTask(at index: Int) {
        var taskList = fetchData()
        taskList.remove(at: index)
        saveContext()
    }
    
    func update(task: TodoTask, newTitle: String) {
        task.title = newTitle
        saveContext()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
  
    func saveContext () {
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
}
