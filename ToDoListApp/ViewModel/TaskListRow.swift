//
//  TaskListRow.swift
//  ToDoListApp
//
//  Created by Amelie Pocchiolo on 04/01/2023.
//

import SwiftUI

struct TaskListRow: View {
    @ObservedObject var task: Task
    @Environment(\.managedObjectContext) private var viewContext
    // save the update
    
    var body: some View {
        Toggle(isOn: self.$task.complete) {
            HStack {
                Text(self.task.name)
                
                Spacer()
                
             //   Text(String(self.task.date.formatted(.dateTime.hour().minute())))
                
              //  time(task: task)

                Spacer()
                
                Circle()
                    .frame(width: 10)
                    .foregroundColor(self.task.priority.priorityColor())
            }
            .fontWeight(.bold)
            .strikethrough(self.task.complete, color :
                            self.task.priority.priorityColor())
            .opacity(self.task.complete ? 0.5 : 1)
        }
        .toggleStyle(CheckboxStyle(taskColor: self.task.priority.priorityColor()))
        .onReceive(self.task.objectWillChange){  _ in
            if self.viewContext.hasChanges {
                try? self.viewContext.save()
            }
        }
    }
    
//    private let itemFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .short
//        formatter.timeStyle = .short
//       // date.formatted(.dateTime.day())
//        return formatter
//    }()
    
}

struct TaskListRow_Previews: PreviewProvider {
    static var previews: some View {
        let testTask = Task(context: PersistenceController.preview.container.viewContext)
        testTask.id = UUID()
        testTask.name = "Test Task"
        testTask.complete = false
        testTask.priority = .low
        testTask.order = 0
        testTask.date = Date.now
        
        return TaskListRow(task: testTask)
    }
}
//
//struct time: View {
//    @ObservedObject var task: Task
//
//    var body: some View {
//        Text(String(self.task.date.formatted(.dateTime.hour().minute())))
//    }
//}
