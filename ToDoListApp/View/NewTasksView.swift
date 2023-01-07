//
//  NewTasksView.swift
//  ToDoListApp
//
//  Created by Amelie Pocchiolo on 04/01/2023.
//

import SwiftUI

struct NewTasksView: View {
 
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Task.complete, ascending:  true),
            NSSortDescriptor(keyPath: \Task.priorityNum, ascending:  false),
            NSSortDescriptor(keyPath: \Task.date, ascending:  false)
        ],
        animation: .default
    )
    
    private var tasks: FetchedResults<Task>
    
    @State private var taskName: String = ""
    @State private var taskPriority: Priority = .normal
    @State private var isEditing: Bool = false
    
    @State private var taskdate = Date()
    @State private var taskAlarm = Date()
    
    let notify = NotificationHandler()
    
    var body: some View {
        ScrollView {
            VStack{
                VStack(alignment: .leading) {
                    HStack {
                        Text("Add new Task")
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                    .padding(.vertical)
                    
                    TextField("New task Name", text:  self.$taskName, onEditingChanged:
                    {
                        self.isEditing = $0
                        
                    })
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.bottom)
                    
                    HStack{
                        
                        Text("Priority")
                            .fontWeight(.semibold)
                            .padding(.vertical)
                        
                        Spacer()

                            PriorityView(priorityTitle: "High", selectedPriority: self.$taskPriority)
                                .onTapGesture {
                                    self.taskPriority = .high
                                }
                            PriorityView(priorityTitle: "Normal", selectedPriority: self.$taskPriority)
                                .onTapGesture {
                                    self.taskPriority = .normal
                                }
                            PriorityView(priorityTitle: "Low", selectedPriority: self.$taskPriority)
                                .onTapGesture {
                                    self.taskPriority = .low
                                    
                                }
                    }
                    .padding(.bottom)
                    
                    VStack{
                        DatePicker("Date", selection: self.$taskdate , in: Date.now...,displayedComponents: [.date])
                           //.accentColor(.accentColor)
                            .fontWeight(.semibold)
                            .padding(.vertical)
                        
                        DatePicker("Alarm", selection: self.$taskAlarm , in: Date.now...,displayedComponents: [.date, .hourAndMinute])
                            //.accentColor(.accentColor)
                            .fontWeight(.semibold)
                            .padding(.vertical)
                    }
                    
                    Spacer()
                    
                    Button {
                        notify.sendNotification(
                            date: taskAlarm,
                            type: "date",
                            title: "Date based notification",
                            body: "Hey ! You need to do \(taskName) before the \(taskdate). It's \($taskPriority) priority")
                        
                        guard self.taskName.trimmingCharacters(in: .whitespaces) != ""
                        else {
                            return
                        }
                        
                        self.addNewTask(name: self.taskName, date: self.taskdate, priority: self.taskPriority, alarm: self.taskAlarm)
                        
                        dismiss()
                        
                    } label: {
                        Text("Add new task")
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
    }
    
    private func addNewTask(name: String, date: Date, priority: Priority, alarm: Date) -> Void {
        let newTask  = Task(context: viewContext)
        newTask.id = UUID()
        newTask.name = name
        newTask.priority = priority
        newTask.complete = false
        newTask.order = (tasks.last?.order ?? 0) + 1
        newTask.date = date
        newTask.alarm = alarm
        
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct NewTasksView_Previews: PreviewProvider {
    static var previews: some View {
        NewTasksView()
    }
}
