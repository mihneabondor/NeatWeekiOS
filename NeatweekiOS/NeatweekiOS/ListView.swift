//
//  ContentView.swift
//  NeatweekiOS
//
//  Created by Mihnea on 12/25/22.
//

import SwiftUI

struct ListView: View {
    @State var filter : String = Functions.SharedInstance.getStartingPage()
    @State private var viewSpecificTask = [Task]()
    
    // variables for alert
    @State private var presentAddAlert : Bool = false
    @State private var newTaskText = String()
    
    var body: some View {
        VStack{
            HStack{
                Text(filter)
                    .font(.title)
                    .bold()
                    .padding()
                Spacer()
                Button() {
                    presentAddAlert = true
                } label: {
                    Image(systemName: "plus")
                }
                .padding()
            }
            if viewSpecificTask.isEmpty {
                VStack {
                    Spacer()
                    Text("No tasks in the \(filter) page")
                        .bold()
                    Text("Please add a new task by clicking the + icon")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            List(viewSpecificTask, id: \.id) {task in
                Text(task.text)
                    .strikethrough(task.completed)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            withAnimation{
                                let tasksIndex = tasks.firstIndex(where: {$0.text == task.text})
                                tasks.remove(at: tasksIndex!)
                                
                                let viewSpecificTaskIndex = viewSpecificTask.firstIndex(where: {$0.id == task.id})
                                viewSpecificTask.remove(at: viewSpecificTaskIndex!)
                                
                                Functions.SharedInstance.saveData(key: userDefaultsSaveKey, array: tasks)
                            }
                        } label: {
                            Image(systemName: "trash.fill")
                        }
                    }
                    .swipeActions(edge: .leading) {
                        Button() {
                            withAnimation{
                                var nextFilter = String()
                                switch filter {
                                case "Later":
                                    nextFilter = "Week"
                                case "Week":
                                    nextFilter = "Today"
                                default:
                                    nextFilter = "Later"
                                }
                                
                                let tasksIndex = tasks.firstIndex(where: {$0.text == task.text})
                                tasks[tasksIndex!].due = nextFilter
                                let viewSpecificTaskIndex = viewSpecificTask.firstIndex(where: {$0.id == task.id})
                                viewSpecificTask.remove(at: viewSpecificTaskIndex!)
                                Functions.SharedInstance.saveData(key: userDefaultsSaveKey, array: tasks)
                            }
                            
                        } label: {
                            if filter != "today" {
                                Image(systemName: "arrowshape.turn.up.right.fill")
                            } else {
                                Image(systemName: "arrowshape.turn.up.left.fill")
                            }
                        }
                        .tint(.indigo)
                        
                        Button() {
                            withAnimation {
                                let tasksIndex = tasks.firstIndex(where: {$0.text == task.text})
                                tasks[tasksIndex!].completed.toggle()
                                tasks.sort(by: {!$0.completed && $1.completed})
                                
                                let viewSpecificTaskIndex = viewSpecificTask.firstIndex(where: {$0.id == task.id})
                                
                                viewSpecificTask[viewSpecificTaskIndex!].completed.toggle()
                                
                                viewSpecificTask.sort(by: {!$0.completed && $1.completed})
                                
                                Functions.SharedInstance.saveData(key: userDefaultsSaveKey, array: tasks)
                            }
                        } label: {
                            Image(systemName: "checkmark")
                        }
                    }
            }
            .listStyle(.grouped)
            .scrollContentBackground(.hidden)
            .alert("Add Task", isPresented: $presentAddAlert, actions: {
                TextField("Name", text: $newTaskText)
                Button("Add", action: {
                    withAnimation {
                        viewSpecificTask.insert(Task(text: newTaskText, due: filter), at: 0)
                        
                        tasks.insert(Task(text: newTaskText, due: filter), at: 0)
                        
                        Functions.SharedInstance.saveData(key: userDefaultsSaveKey, array: tasks)
                        newTaskText = String()
                        
                        viewSpecificTask.sort(by: {!$0.completed && $1.completed})
                    }
                })
                Button("Cancel", role: .cancel, action: {})
            })
            .padding()
            .navigationTitle(filter)
            .onAppear() {
                viewSpecificTask = Functions.SharedInstance.getData(key: userDefaultsSaveKey).filter({$0.due == filter})
                
                // Notifications
                LocalNotifications.sharedInstance.requestPermission()
                LocalNotifications.sharedInstance.beginningOfWeekNotification()
            }
            .onChange(of: filter) { _ in
                withAnimation{
                    viewSpecificTask = Functions.SharedInstance.getData(key: userDefaultsSaveKey).filter({$0.due == filter})
                }
            }
            BottomBarView(filter: $filter)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
