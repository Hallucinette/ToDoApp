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
    
   // @State private var taskName: String = ""
    @State private var newName: String = ""
   // @State private var taskPriority: Priority = .normal
    @State private var newPriority: Priority = .high
    @State private var newDate: Date = .now
    @State private var newAlert: Date = .now
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            
            Text("Update Task's Data")
                .fontWeight(.semibold)
            
            VStack(alignment: .leading){
                
                TextField("New task Name", text:  $task.name)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.bottom)
                // PRIORITY
                
                
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
                .padding(.vertical)
                
                // DATE

                DatePicker("Select a date", selection: self.$newDate , in: Date.now...,displayedComponents: [.date, .hourAndMinute])
                .accentColor(.pink)
                .fontWeight(.semibold)
                .padding(.vertical)
                
                //ALERT
                
                DatePicker("Alert", selection: self.$newAlert , in: Date.now...,displayedComponents: [.date, .hourAndMinute])
                .accentColor(.pink)
                .fontWeight(.semibold)
                .padding(.vertical)
                
                
                
                
                // ****************************//
                
                
                Button {
                    if !task.name.isEmpty && !newName.isEmpty {
                        task.name = newName
                        //self.updateTask()
                    }
                    
                    if  task.priority != newPriority
                    {
                        task.priority = newPriority
   //                     self.updateTask()
                    }
   //                 if task.date != newDate {
                        task.date = newDate
                        self.updateTask()
  //                  }
                    dismiss()
                    
                } label: {
                    Text("Update")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.orange))
                    
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
    
//    struct InitNewDataTask {
//        @ObservedObject var task: Task
//        var newAlert: Date
//        init() {
//            newAlert = task.alert
//        }
//    }
  //  var newData = InitNewDataTask()
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
        testTask.alert = Date.now
        
        return EditView(task: testTask)
    }
}
