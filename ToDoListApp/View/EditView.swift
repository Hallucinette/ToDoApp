//
//  EditView.swift
//  ToDoListApp
//
//  Created by Amelie Pocchiolo on 05/01/2023.
//

import SwiftUI
import Foundation

struct EditView: View {
    @ObservedObject var task: TaskList
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var newName: String = ""
    @State private var newPriority: Priority = .high
    @State private var newDate: Date = .now
    @State private var newAlarm: Date = .now
    @State var vm = ViewModel()
    
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
                
                TextField("\(task.name)", text: $newName)
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
                .onAppear {
                    newPriority = task.priority
                }
                .padding(.bottom)

                VStack{
                    DatePicker("Date", selection: self.$newDate , in: task.date...,displayedComponents: [.date])
                        .accentColor(.pink)
                        .fontWeight(.semibold)
                        .padding(.vertical)
                        .onAppear {
                            newDate = task.date
                        }
                }
                
                VStack{
                    DatePicker("Alarm", selection: self.$newAlarm , in: task.alarm...,displayedComponents: [.date, .hourAndMinute])
                        .accentColor(.pink)
                        .fontWeight(.semibold)
                        .padding(.vertical)
                        .onAppear {
                            newAlarm = task.alarm
                        }
                }
                
                Spacer()
               
                Button {
                    vm.updateTask(newName: newName, newDate: newDate, newPriority: newPriority, newAlarm: newAlarm, task: task)
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
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        let testTask = TaskList(context: PersistenceController.preview.container.viewContext)
        testTask.id = UUID()
        testTask.name = "Test Task"
        testTask.complete = false
        testTask.priority = .high
        testTask.order = 1
        testTask.date = Date.now
        
        return EditView(task: testTask)
    }
}
