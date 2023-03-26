//
//  AlertView.swift
//  ToDoListApp
//
//  Created by Amelie Pocchiolo on 06/01/2023.
//

import SwiftUI

struct AlertView: View {
    @ObservedObject var task: TaskList
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(task.priority.priorityColor(), lineWidth: 10)
                .frame(width: 300, height: 100)
            VStack {
                Text("Alert for")
                    .font(.system(size: 16, weight: .black, design: .serif))
                    .fontWeight(.bold)
                Text(String(task.date.formatted(.dateTime.day().month().year())))
                    .font(.system(size: 26, weight: .black, design: .serif))
                    .fontWeight(.bold)
                Text(String(task.alarm.formatted(.dateTime.minute().hour())))
                    .font(.system(size: 26, weight: .black, design: .serif))
                    .fontWeight(.bold)
            }
            
        }
    }
}


struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        let testTask = TaskList(context: PersistenceController.preview.container.viewContext)
        testTask.id = UUID()
        testTask.name = "Test Task"
        testTask.complete = false
        testTask.priority = .low
        testTask.order = 0
        testTask.date = Date.now
        testTask.alarm = Date.now
        
        return AlertView(task: testTask)
    }
}
