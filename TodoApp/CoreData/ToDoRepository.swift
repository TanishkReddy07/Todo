//
//  ToDoRepository.swift
//  TodoApp
//
//  An app for creating todo list
//
//  Created by Group-7
//  Tanishk Sai Reddy Peruvala-301293616
//  Jashandeep Kaur Sidhu-301293237
//  Pujan Prasai-301290876
//  on 2022-11-27.
//

import Foundation
import CoreData

enum ToDoRepositoryError: Error {
    case FetchingFailed
    case IdNotFound
    case DeletionFailed
}

extension ToDoRepositoryError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .FetchingFailed:
            return NSLocalizedString(
                "Fetching todo list failed",
                comment: ""
            )
        case .IdNotFound:
            return NSLocalizedString(
                "Todo item not found",
                comment: ""
            )
        case .DeletionFailed:
            return NSLocalizedString(
                "Deleting Failed",
                comment: ""
            )
        }
    }
}

// respository class for doind CRUD on ToDo coredata entity
class ToDoRepository {
    
    static let shared = ToDoRepository()
    
    let context = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
    
    private init () {}
    
    // get all saved ToDo as an array
    func getToDoList() async throws->  [Todo] {
        let todoListFetch: NSFetchRequest<Todo> = Todo.fetchRequest()
        let sortByDate = NSSortDescriptor(key: #keyPath(Todo.dateAdded), ascending: false)
        todoListFetch.sortDescriptors = [sortByDate]
            do {
                let results = try context.fetch(todoListFetch)
                return results
            } catch let error as NSError {
                print("Fetch error: \(error) description: \(error.userInfo)")
                throw ToDoRepositoryError.FetchingFailed
            }
        
    }
    
    
    // Add new ToDo
    func addTodo(name: String, hasDueDate: Bool, isCompleted: Bool, dueDate: Date?, notes: String) async -> Todo {
        let newTodo = Todo(context: context)
        newTodo.setValue(UUID(), forKey: #keyPath(Todo.itemId))
        newTodo.setValue(Date(), forKey: #keyPath(Todo.dateAdded))
        newTodo.setValue(name, forKey: #keyPath(Todo.name))
        newTodo.setValue(hasDueDate, forKey: #keyPath(Todo.hasDueDate))
        newTodo.setValue(isCompleted, forKey: #keyPath(Todo.isCompleted))
        newTodo.setValue(dueDate, forKey: #keyPath(Todo.dueDate))
        newTodo.setValue(notes, forKey: #keyPath(Todo.notes))
        await AppDelegate.sharedAppDelegate.coreDataStack.saveContext() // Save changes in CoreData
        return newTodo
    }
    
    // delete a ToDo
    func deleteTodo(object: Todo) async throws -> Todo? {
        //let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        //fetchRequest.predicate = NSPredicate.init(format: "itemId==\(id)")
        
        do {
            
            
            context.delete(object)
            
            try context.save()
            return object
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
            throw ToDoRepositoryError.FetchingFailed
        }
        
    }
    
    //update a ToDo
    func updateTodo(name: String, hasDueDate: Bool, isCompleted: Bool, dueDate: Date?, notes: String,object: Todo) async throws -> Todo? {
        do {
            
            object.setValue(object.itemId, forKey: #keyPath(Todo.itemId))
            object.setValue(object.dateAdded, forKey: #keyPath(Todo.dateAdded))
            object.setValue(name, forKey: #keyPath(Todo.name))
            object.setValue(hasDueDate, forKey: #keyPath(Todo.hasDueDate))
            object.setValue(isCompleted, forKey: #keyPath(Todo.isCompleted))
            object.setValue(dueDate, forKey: #keyPath(Todo.dueDate))
            object.setValue(notes, forKey: #keyPath(Todo.notes))
            
            try context.save()
            return object
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
            throw ToDoRepositoryError.FetchingFailed
        }
    }
    
}
