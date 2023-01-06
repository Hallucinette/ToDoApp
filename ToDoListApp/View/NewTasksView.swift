//
//  NewTasksView.swift
//  ToDoListApp
//
//  Created by Amelie Pocchiolo on 04/01/2023.
//

import SwiftUI

struct NewTasksView: View {
 
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
    
    @Binding var isShow: Bool
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var taskName: String = ""
    @State private var taskPriority: Priority = .normal
    @State private var isEditing: Bool = false
    
    @State private var taskdate = Date()
    @State private var taskAlert = Date()
    
   // let notify = NotificationData()
    
    var body: some View {
        ScrollView {
            VStack{
               // Spacer()
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Add new Task")
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button(action: {
                            self.isShow = false
                        }) {
                            Image(systemName: "xmax.circle.fill")
                                .font(.title3)
                                .foregroundColor(self.taskPriority.priorityColor())
                        }
                    }
                    
                    TextField("New task Name", text:  self.$taskName, onEditingChanged:
                    {
                        self.isEditing = $0
                        
                    })
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.bottom)
                    
                    HStack {
                        Text("Priority")
                            .fontWeight(.semibold)
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

                    DatePicker("Date", selection: self.$taskdate , in: Date.now...,displayedComponents: [.date, .hourAndMinute])
                    .accentColor(.pink)
                    .fontWeight(.semibold)
                    
                    DatePicker("Alert", selection: self.$taskAlert , in: Date.now...,displayedComponents: [.date, .hourAndMinute])
                    .accentColor(.pink)
                    .fontWeight(.semibold)
                    
                    
                    Button {
                        
                        notify.sendNotification(
                            date: taskAlert,
                            type: "date",
                            title: "Notification programmé",
                            body: "This is a reminder for you task")
                        guard self.taskName.trimmingCharacters(in: .whitespaces) != ""
                        else {
                            return
                        }
                        
                        self.isShow = false
                        self.addNewTask(name: self.taskName, date: self.taskdate, priority: self.taskPriority, alert: taskAlert)
                        
                        // here xe will ne the code to add to Coredata
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
                .background(Color.white)
                .cornerRadius(10, antialiased:  true)
               // .offset(y: self.isEditing ? -320 : 0)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
    
    private func addNewTask(name: String, date: Date, priority: Priority, alert: Date) -> Void {
        let newTask  = Task(context: viewContext)
        newTask.id = UUID()
        newTask.name = name
        newTask.priority = priority
        newTask.complete = false
        newTask.order = (tasks.last?.order ?? 0) + 1
        newTask.date = date
        newTask.alert = date
        
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct NewTasksView_Previews: PreviewProvider {
    static var previews: some View {
        NewTasksView(isShow: .constant(true))
    }
}
