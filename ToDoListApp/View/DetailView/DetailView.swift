//
//  DetailView.swift
//  ToDoListApp
//
//  Created by Amelie Pocchiolo on 05/01/2023.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var task: TaskList
    @Environment(\.managedObjectContext) private var viewContext
    
    
    var body: some View {
        VStack{
            Spacer()
            
            CalendarRectangleView(task: task)
                .padding()
            AlertView(task: task)
            
            Spacer()
        }
        .navigationTitle(String(task.name))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareLink(item: "Hey ! You have a New Task ! \(task.name). It's \(task.priority) priority")
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: {
                    EditView(task: task)
                }, label: {
                    Image(systemName: "pencil")
                        .foregroundColor(.accentColor)
                })
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        let testTask = TaskList(context: PersistenceController.preview.container.viewContext)
        testTask.id = UUID()
        testTask.name = "Test Task"
        testTask.complete = false
        testTask.priority = .high
        testTask.order = 1
        testTask.date = Date.now
        testTask.alarm = Date.now
        
        return DetailView(task: testTask)
    }
}
