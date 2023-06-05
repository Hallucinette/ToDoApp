//
//  ViewModel.swift
//  ToDoListApp
//
//  Created by Amelie Pocchiolo on 01/03/2023.
//

import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    
    @Published var pendingRequests: [UNNotificationRequest] = []
    let notificationCenter = UNUserNotificationCenter.current()

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
    @Published var tasksTab: [TaskList] = []

    func scheduleNotification(task: TaskList) {
        let idNotification = task.id
        let content = UNMutableNotificationContent()
        content.title = "\(task.name)"
        content.subtitle = "Hey ! You need to do \(task.name) before the \(task.date.formatted(.dateTime.weekday(.wide).month(.wide).day())). It's \(task.priority) priority"
        content.sound = UNNotificationSound.default
        let dateComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: task.alarm)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: idNotification.uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
    
    func deleteTask(offsets: IndexSet, tasks: FetchedResults<TaskList>) {
        withAnimation {
            let task = offsets.map { tasks[$0] }
            NotificationManager().removePendingNotification(id: task.first!.id.uuidString)
            offsets.map { tasks[$0] }.forEach(viewContext.delete)
            tasksTab.remove(atOffsets: offsets)
            saveTask()
        }
    }

    func addNewTask(name: String, date: Date, priority: Priority, alarm: Date) -> Void {
        let newTask  = TaskList(context: viewContext)
        newTask.id = UUID()
        newTask.name = name
        newTask.priority = priority
        newTask.complete = false
        newTask.order = (tasks.last?.order ?? 0) + 1
        newTask.date = date
        newTask.alarm = alarm
        scheduleNotification(task: newTask)
        saveTask()
    }
    
    func updateTask(newName: String, newDate: Date, newPriority: Priority, newAlarm: Date, task: TaskList) {
        if !newName.isEmpty {
            task.name = newName
        }
        if  task.priority != newPriority {
            task.priority = newPriority
        }
        if task.date != newDate {
            task.date = newDate
        }
        if task.alarm != newAlarm {
            NotificationManager().removePendingNotification(id: task.id.uuidString)
            task.alarm = newAlarm
            scheduleNotification(task: task)
        }
        saveTask()
    }
    
    func saveTask() {
        do {
            try viewContext.save()
        }
        catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError.localizedDescription), \(nsError.userInfo)")
        }
    }
}
