//
//  ViewModel.swift
//  ToDoListApp
//
//  Created by Amelie Pocchiolo on 01/03/2023.
//

import Foundation
import SwiftUI

class ViewModel: ObservableObject {

    let viewContext = PersistenceController.shared.container.viewContext
    
    @FetchRequest(
        entity: TaskList.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \TaskList.complete, ascending:  true),
            NSSortDescriptor(keyPath: \TaskList.order, ascending:  true),
            NSSortDescriptor(keyPath: \TaskList.date, ascending: true),
            NSSortDescriptor(keyPath: \TaskList.priorityNum, ascending:  false)
        ],
        animation: .default
    )
    
    private var tasks: FetchedResults<TaskList>

    func addNewTask(name: String, date: Date, priority: Priority, alarm: Date) -> Void {
        let newTask  = TaskList(context: viewContext)
        newTask.id = UUID()
        newTask.name = name
        newTask.priority = priority
        newTask.complete = false
        newTask.order = (tasks.last?.order ?? 0) + 1
        newTask.date = date
        newTask.alarm = alarm

        updateTask()
    }
    
    func updateTask() {
        do {
            try viewContext.save()
        }
        catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError.localizedDescription), \(nsError.userInfo)")
        }
    }
}
