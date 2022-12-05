//
//  Todo+CoreDataClass.swift
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
import UIKit

@objc(Todo)
public class Todo: NSManagedObject {
    func getDuteDate() -> NSAttributedString {
        
        
        if self.hasDueDate {
            let dateString = formatDate(date: self.dueDate!)
            if self.dueDate! < Date() && !self.isCompleted {
                let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.red ]
                let myAttrString = NSAttributedString(string: dateString, attributes: myAttribute)
                return myAttrString
            } else {
                let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.gray ]
                let myAttrString = NSAttributedString(string: dateString, attributes: myAttribute)
                return myAttrString
            }
        } else {
            return NSAttributedString(string: "", attributes: [:])
        }
    }
    
    func formatDate(date: Date) -> String {

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy h:mm a"

        
        return dateFormatterPrint.string(from: date)
    }
}
