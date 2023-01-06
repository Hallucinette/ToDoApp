//
//  ContentView.swift
//  ToDoListApp
//
//  Created by Amelie Pocchiolo on 04/01/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Task.complete, ascending:  true),
            NSSortDescriptor(keyPath: \Task.order, ascending:  true),
            NSSortDescriptor(keyPath: \Task.date, ascending: true),
            NSSortDescriptor(keyPath: \Task.priorityNum, ascending:  false)
        
        ],
        animation: .default
    )
    
    private var tasks: FetchedResults<Task>
    
    @State private var showNewTask: Bool = false
    @State private var searchText: String = ""

    var body: some View {
        NavigationView{
            ZStack {
                Form {
                    ForEach(tasks.filter { searchText.isEmpty ? true : $0.name.contains(searchText)}) { task in
                        NavigationLink {
                            DetailView(task: task)
                        } label: {
                            HStack {
                                TaskListRow(task: task)
                            }
                        }
                    }
                    .onMove(perform: moveTask)
                    .onDelete(perform: deleteTask)
                }
                
                if self.showNewTask {
                    BlankView()
                        .onTapGesture {
                            self.showNewTask = false
                        }

                    NewTasksView(isShow: self.$showNewTask)
                        .transition(.move(edge: .bottom))
                        .animation(.default, value: self.showNewTask)
                }
            }
            .navigationTitle("Task")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.showNewTask = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.accentColor)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                    
                        .foregroundColor(.accentColor)
                        .opacity(self.tasks.count == 0 ? 0.5 : 1)
                        .disabled(self.tasks.count == 0)
                }
            }
        }
        .searchable(text: self.$searchText)
    }
    
    private func moveTask(at sets:IndexSet,destination:Int){
        let TaskToMove = sets.first!
        
        if TaskToMove < destination{
            var startIndex = TaskToMove + 1
            let endIndex = destination - 1
            var startOrder = tasks[TaskToMove].order
            while startIndex <= endIndex{
                tasks[startIndex].order = startOrder
                startOrder = startOrder + 1
                startIndex = startIndex + 1
            }
            tasks[TaskToMove].order = startOrder
        }
        else if destination < TaskToMove{
            var startIndex = destination
            let endIndex = TaskToMove - 1
            var startOrder = tasks[destination].order + 1
            let newOrder = tasks[destination].order
            while startIndex <= endIndex{
                tasks[startIndex].order = startOrder
                startOrder = startOrder + 1
                startIndex = startIndex + 1
            }
            tasks[TaskToMove].order = newOrder
        }
        
        do{
            try viewContext.save()
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    //delete function
    // this function is given by Apple in CoreData template
    
//    // 2.
//     private func deleteTask(offsets: IndexSet) {
//         withAnimation {
//             tasks.remove(atOffsets: offsets)
//
//             do {
//                 try viewContext.save()
//             }
//             catch {
//                 let nsError = error as NSError
//                 print(nsError.localizedDescription)
//             }
//         }
//     }
    
    private func deleteTask(index: IndexSet) -> Void {
        withAnimation {
            index.map { tasks[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            }
            catch {
                let nsError = error as NSError
                print(nsError.localizedDescription)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let testTask = Task(context: PersistenceController.preview.container.viewContext)
        testTask.id = UUID()
        testTask.name = "Test Task"
        testTask.complete = false
        testTask.priority = .low
        testTask.order = 1
        testTask.date = Date.now
        
        return ContentView()
    }
}
