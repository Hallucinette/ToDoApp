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
    @State var vm = ViewModel()
    
    @FetchRequest(
        entity: TaskList.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \TaskList.complete, ascending:  true),
            NSSortDescriptor(keyPath: \TaskList.priorityNum, ascending:  false),
            NSSortDescriptor(keyPath: \TaskList.date, ascending:  false),
            NSSortDescriptor(keyPath: \TaskList.alarm, ascending:  false)
        ],
        animation: .default
    )
    
    private var tasks: FetchedResults<TaskList>
    
    @State private var taskName: String = ""
    @State private var taskPriority: Priority = .normal
    @State private var isEditing: Bool = false
    @State private var isEmpty: Bool = false
    
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
                   // .accessibilityIdentifier("taskName")
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
                            .fontWeight(.semibold)
                            .padding(.vertical)
                            .accessibilityIdentifier("Date")
                        
                        DatePicker("Alarm", selection: self.$taskAlarm , in: Date.now...,displayedComponents: [.date, .hourAndMinute])
                            .fontWeight(.semibold)
                            .padding(.vertical)
                            .accessibilityIdentifier("Alarm")
                    }
                    
                    Spacer()
                    
                    Button {
                        guard self.taskName.trimmingCharacters(in: .whitespaces) != ""
                        else {
                            if self.taskName == "" {
                                self.isEmpty = true
                            } else {
                                self.isEmpty = false
                            }
                            return
                        }

                        vm.addNewTask(name: self.taskName, date: self.taskdate, priority: self.taskPriority, alarm: self.taskAlarm)
                        
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
                    .alert("Oh !", isPresented: $isEmpty) {
                        Button("Confirm") {
                            isEmpty.toggle()
                        }
                    } message: {
                        Text("Please, write a name")
                    }
                }
                .accessibilityIdentifier("AddButton")
                .padding()
            }
        }
    }
}

struct NewTasksView_Previews: PreviewProvider {
    static var previews: some View {
        NewTasksView()
    }
}
