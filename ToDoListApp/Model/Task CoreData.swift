//
//  Task CoreData.swift
//  ToDoListApp
//
//  Created by Amelie Pocchiolo on 04/01/2023.
//

import SwiftUI
import CoreData

@objc(TaskList)
public class TaskList: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var complete: Bool
    @NSManaged public var priorityNum: Int32
    @NSManaged public var order: Int64
    @NSManaged public var date: Date
    @NSManaged public var alarm: Date
}

extension TaskList: Identifiable {
    var priority: Priority {
        get {
            Priority(rawValue: Int(priorityNum)) ?? .normal
        }
        
        set {
            self.priorityNum = Int32(newValue.rawValue)
        }
    }
}

enum Priority: Int {
    case low = 0
    case normal = 1
    case high = 2
    
    var priorityType: String {
        switch self {
        case Priority.low : return "low"
        case Priority.normal : return "normal"
        case Priority.high : return "high"
        }
    }
    
    // to set color for each type of priorities
    
    func priorityColor() -> Color {
        switch self {
        case Priority.low : return .green
        case Priority.normal : return .orange
        case Priority.high : return .red
        }
    }
}
