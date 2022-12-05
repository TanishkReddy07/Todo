//
//  Todo+CoreDataProperties.swift
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


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var itemId: UUID
    @NSManaged public var name: String
    @NSManaged public var notes: String
    @NSManaged public var isCompleted: Bool
    @NSManaged public var hasDueDate: Bool
    @NSManaged public var dueDate: Date?
    @NSManaged public var dateAdded: Date?
    

}

extension Todo : Identifiable {

}
