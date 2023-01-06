//
//  Task CoreData.swift
//  ToDoListApp
//
//  Created by Amelie Pocchiolo on 04/01/2023.
//

import SwiftUI
import CoreData

@objc(Task)
public class Task: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var complete: Bool
    @NSManaged public var priorityNum: Int32
    @NSManaged public var order: Int64
    @NSManaged public var date: Date
    @NSManaged public var alert: Date
}

extension Task: Identifiable {
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
        switch rawValue {
        case Priority.low.rawValue: return "low"
        case Priority.normal.rawValue: return "normal"
        case Priority.high.rawValue: return "high"
        
        default: return ""
        }
    }
    
    // to set color for each type of priorities
    
    func priorityColor() -> Color {
        switch rawValue {
        case Priority.low.rawValue: return .green
        case Priority.normal.rawValue: return .orange
        case Priority.high.rawValue: return .red
            
        default: return .orange
        }
    }
}
//struct Task_CoreData: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//struct Task_CoreData_Previews: PreviewProvider {
//    static var previews: some View {
//        Task_CoreData()
//    }
//}
