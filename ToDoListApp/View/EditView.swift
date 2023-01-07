//
//  EditView.swift
//  ToDoListApp
//
//  Created by Amelie Pocchiolo on 05/01/2023.
//

import SwiftUI
import Foundation

struct EditView: View {
    @ObservedObject var task: Task
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var newName: String = ""
    @State private var newPriority: Priority = .high
    @State private var newDate: Date = .now
    @State private var newAlarm: Date = .now
    
    let notify = NotificationHandler()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading){
                HStack {
                    Text("Update Data")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                    
                    Spacer()
                }
                .padding(.vertical)
                
                TextField("Task name", text:  $newName)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.bottom)
                
                HStack {
                    Text("Priority")
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    PriorityView(priorityTitle: "High", selectedPriority: $newPriority)
                        .onTapGesture {
                            newPriority = .high
                        }
                    PriorityView(priorityTitle: "normal", selectedPriority:  $newPriority)
                        .onTapGesture {
                            newPriority = .normal
                        }
                    PriorityView(priorityTitle: "low", selectedPriority: $newPriority)
                        .onTapGesture {
                            newPriority = .low

                        }
                }
                .padding(.bottom)

                VStack{
                    DatePicker("Date", selection: self.$newDate , in: Date.now...,displayedComponents: [.date])
                        //.accentColor(.pink)
                        .fontWeight(.semibold)
                        .padding(.vertical)
                }
                
                VStack{
                    DatePicker("Alarm", selection: self.$newAlarm , in: Date.now...,displayedComponents: [.date, .hourAndMinute])
                        //.accentColor(.pink)
                        .fontWeight(.semibold)
                        .padding(.vertical)
                }
                
                Spacer()
               
                Button {
                    
                    notify.sendNotification(
                        date: newAlarm,
                        type: "date",
                        title: "ToDo List",
                        body: "Hey ! You need to do \(newName) before the \(newDate). It's \(newPriority) priority")
                    
                    if !newName.isEmpty  {
                        task.name = newName
                        self.updateTask()
                    }
                    
                    if  task.priority != newPriority
                    {
                        task.priority = newPriority
                        self.updateTask()
                    }
                    if task.date != newDate {
                        task.date = newDate
                        self.updateTask()
                    }
                    
                    if task.alarm != newAlarm {
                        task.alarm = newAlarm
                        self.updateTask()
                    }
                    
                    dismiss()
                    
                } label: {
                    Text("Update")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.pink)
                }
                .cornerRadius(10)
                .padding(.vertical)
            }
            .padding()
        }
    }
    
    private func updateTask() {
        
        do {
            try viewContext.save()
        }
        catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError.localizedDescription), \(nsError.userInfo)")
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        let testTask = Task(context: PersistenceController.preview.container.viewContext)
        testTask.id = UUID()
        testTask.name = "Test Task"
        testTask.complete = false
        testTask.priority = .high
        testTask.order = 1
        testTask.date = Date.now
        
        return EditView(task: testTask)
    }
}
