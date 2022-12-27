//
//  ContentView.swift
//  NeatweekiOS
//
//  Created by Mihnea on 12/25/22.
//

import SwiftUI

struct ListView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State var filter : String = Functions.SharedInstance.getStartingPage()
    @State private var viewSpecificTask = [Task]()
    
    // variables for alert
    @State private var presentAddAlert : Bool = false
    @State private var newTaskText = String()
    
    enum Direction {
        case next, previous
    }
    
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
                    .foregroundColor(task.completed ? Color.gray : colorScheme == .dark ? Color.white : Color.black)
                    .strikethrough(task.completed)
                    .swipeActions(edge: .trailing) {
                        if filter == "Later" {
                            Button(role: .destructive) {deleteSwipeButton(task: task)} label: {Image(systemName: "trash.fill")}
                        } else {
                            Button {moveSwipeButton(task: task, direction: .previous)} label: {Image(systemName: "arrowshape.turn.up.left.fill")}.tint(.indigo)
                            Button(role: .destructive) {deleteSwipeButton(task: task)} label: {Image(systemName: "trash.fill")}
                        }
                    }
                    .swipeActions(edge: .leading) {
                        if filter != "Today" {
                            Button {moveSwipeButton(task: task, direction: .next)} label: {Image(systemName: "arrowshape.turn.up.right.fill")}.tint(.indigo)
                            Button {completeTaskButton(task: task)} label: {Image(systemName: "checkmark.circle.fill")}
                        } else {
                            if task.completed {
                                Button {completeTaskButton(task: task)} label: {Image(systemName: "checkmark.circle.badge.xmark.fill")}
                            } else {
                                Button {completeTaskButton(task: task)} label: {Image(systemName: "checkmark.circle.fill")}
                            }
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
                // Resetting data every day
                let components = Date().get(.day, .weekday)
                if UserDefaults.standard.integer(forKey: userDefaultsTimestampKey) != components.day {
                    var indexesToBeRemoved = [Int]()
                    if components.weekday == 1 {
                        for index in 0..<tasks.count {
                            tasks[index].due = "Later"
                            if tasks[index].completed {
                                indexesToBeRemoved.append(index)
                            }
                        }
                    } else {
                        for index in 0..<tasks.count {
                            if tasks[index].due == "Today" {
                                tasks[index].due = "Week"
                            }
                            if tasks[index].completed {
                                indexesToBeRemoved.append(index)
                            }
                        }
                    }
                    
                    tasks = tasks
                        .enumerated()
                        .filter { !indexesToBeRemoved.contains($0.offset) }
                        .map { $0.element }
                    
                    Functions.SharedInstance.saveData(key: userDefaultsSaveKey, array: tasks)
                    UserDefaults.standard.set(components.day, forKey: userDefaultsTimestampKey)
                }
                filter = Functions.SharedInstance.getStartingPage()
                
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
    
    private func deleteSwipeButton(task : Task) {
        withAnimation{
            let tasksIndex = tasks.firstIndex(where: {$0.text == task.text})
            tasks.remove(at: tasksIndex!)
            
            let viewSpecificTaskIndex = viewSpecificTask.firstIndex(where: {$0.id == task.id})
            viewSpecificTask.remove(at: viewSpecificTaskIndex!)
            
            Functions.SharedInstance.saveData(key: userDefaultsSaveKey, array: tasks)
        }
    }
    
    private func moveSwipeButton(task: Task, direction : Direction) {
        withAnimation{
            var nextFilter = String()
            
            if direction == .next {
                switch filter {
                case "Later":
                    nextFilter = "Week"
                case "Week":
                    nextFilter = "Today"
                default:
                    nextFilter = "Later"
                }
            } else {
                switch filter {
                case "Week":
                    nextFilter = "Later"
                default:
                    nextFilter = "Week"
                }
            }
            
            let tasksIndex = tasks.firstIndex(where: {$0.text == task.text})
            tasks[tasksIndex!].due = nextFilter
            let viewSpecificTaskIndex = viewSpecificTask.firstIndex(where: {$0.id == task.id})
            viewSpecificTask.remove(at: viewSpecificTaskIndex!)
            Functions.SharedInstance.saveData(key: userDefaultsSaveKey, array: tasks)
        }
    }
    
    private func completeTaskButton(task: Task) {
        withAnimation {
            let tasksIndex = tasks.firstIndex(where: {$0.text == task.text})
            tasks[tasksIndex!].completed.toggle()
            tasks[tasksIndex!].due = "Today"
            tasks.sort(by: {!$0.completed && $1.completed})
            
            let viewSpecificTaskIndex = viewSpecificTask.firstIndex(where: {$0.id == task.id})
            
            viewSpecificTask[viewSpecificTaskIndex!].completed.toggle()
            
            if filter != "Today" {
                viewSpecificTask.remove(at: viewSpecificTaskIndex!)
            }
            
            viewSpecificTask.sort(by: {!$0.completed && $1.completed})
            
            Functions.SharedInstance.saveData(key: userDefaultsSaveKey, array: tasks)
        }
        
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
