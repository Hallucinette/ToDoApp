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
    @State var vm = ViewModel()
    
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
    let notify = NotificationHandler()

    @State private var searchText: String = ""
    @State private var showNewTask: Bool = false

    var body: some View {
        NavigationView{
            ZStack {
                Form {
                    ForEach(tasks.filter { searchText.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(searchText)}) { task in
                        NavigationLink {
                            DetailView(task: task)
                        } label: {
                            HStack {
                                TaskListRow(task: task)
                            }
                        }
                    }
                    .onMove(perform: moveTask)
                    .onDelete(perform:  withAnimation { deleteTask })
                }
                if tasks.count == 0 {
                    ZStack {
                        VStack{
                            Image("no-data")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                            Text("Add a New Task")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.accentColor)
                        }
                    }
                }
                VStack {
                    Spacer()
                    Text("Not working Notification?")
                        .foregroundColor(.gray)
                        .italic()
                    Button("Request permissions") {
                        notify.askPermission()
                    }
                }
            }
            .navigationTitle("Task")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: {
                        NewTasksView()
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.accentColor)
                    })
                    .accessibilityIdentifier("AddButton")
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

    func deleteTask(index: IndexSet) -> Void {
        index.map { tasks[$0] }.forEach(viewContext.delete)
        vm.updateTask()
    }

    func moveTask(at sets:IndexSet,destination:Int){
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
        vm.updateTask()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let testTask = TaskList(context: PersistenceController.preview.container.viewContext)
        testTask.id = UUID()
        testTask.name = "Test Task"
        testTask.complete = false
        testTask.priority = .low
        testTask.order = 1
        testTask.date = Date.now
        
        return ContentView()
    }
}
