//
//  DetailView.swift
//  ToDoListApp
//
//  Created by Amelie Pocchiolo on 05/01/2023.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var task: Task
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var isAlarm: Bool = false
   // @State private var showingSheet = false
    
    var body: some View {
        NavigationView() {
            VStack{
                Spacer()
                
                CalendarRectangleView(task: task)
                    .padding()
                Spacer()
                
             // date alarm ?
                
                HStack {
                    Text("Task's Priority : ")
                    Text(String(task.priority.priorityType))
                    Circle()
                        .frame(width: 10)
                        .foregroundColor(self.task.priority.priorityColor())
                        .padding()
            }
                HStack{
                    Text("Taske completed : ")
                    Toggle(isOn: self.$task.complete) {
                        //
                    }
                    .toggleStyle(CheckboxStyle(taskColor: self.task.priority.priorityColor()))
                    .onReceive(self.task.objectWillChange){  _ in
                        if self.viewContext.hasChanges {
                            try? self.viewContext.save()
                        }
                    }
                    .padding()
                }
                Spacer()
            }
        }
        .navigationTitle(String(task.name))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareLink(item: "You have a New Task ! \(task.name) it must be done before \(task.date.formatted()). It's \(task.priority) priority")
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
        let testTask = Task(context: PersistenceController.preview.container.viewContext)
        testTask.id = UUID()
        testTask.name = "Test Task"
        testTask.complete = false
        testTask.priority = .high
        testTask.order = 1
        testTask.date = Date.now
        testTask.alert = Date.now
        
        return DetailView(task: testTask)
    }
}
