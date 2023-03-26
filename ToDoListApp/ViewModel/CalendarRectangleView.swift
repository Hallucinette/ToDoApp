//
//  CalendarRectangleView.swift
//  ToDoListApp
//
//  Created by Amelie Pocchiolo on 05/01/2023.
//

import SwiftUI

struct CalendarRectangleView: View {
    
    @ObservedObject var task: TaskList
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(task.priority.priorityColor(), lineWidth: 10)
                .frame(width: 300, height: 300)
            VStack {
                Text(String(task.date.formatted(.dateTime.weekday(.wide))))
                    .font(.system(size: 36, weight: .black, design: .serif))
                    .fontWeight(.bold)
                Text(String(task.date.formatted(.dateTime.day())))
                    .font(.system(size: 56, weight: .black, design: .serif))
                    .fontWeight(.bold)
                Text(String(task.date.formatted(.dateTime.month(.wide))))
                    .font(.system(size: 36, weight: .black, design: .serif))
                    .fontWeight(.bold)
                    .padding()
            }
        }
    }
}

struct DetailTaskView_Previews: PreviewProvider {
    static var previews: some View {
        let testTask = TaskList(context: PersistenceController.preview.container.viewContext)
        testTask.id = UUID()
        testTask.name = "Test Task"
        testTask.complete = false
        testTask.priority = .low
        testTask.order = 0
        testTask.date = Date.now
        testTask.alarm = Date.now
        
        return CalendarRectangleView(task: testTask)
    }
}
