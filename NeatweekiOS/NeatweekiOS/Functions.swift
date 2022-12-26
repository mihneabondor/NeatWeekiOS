//
//  Functions.swift
//  WallYiOS
//
//  Created by Mihnea on 12/16/22.
//

import Foundation

class Functions {
    static let SharedInstance = Functions()
    
    private init() {}
    
    public func getData(key: String) -> [Task] {
        if let data = UserDefaults.standard.data(forKey: key) {
            do {
                let decoder = JSONDecoder()
                return try decoder.decode([Task].self, from: data)
            } catch {
                print("Unable to Decode Tasks ((error))")
                return [Task]()
            }
        }
        return [Task]()
    }
    
    public func saveData(key: String, array : [Task]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(array)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Unable to Encode Array of Tasks ((error))")
        }
    }
    
    public func getStartingPage() -> String {
        struct pageCounter {
            var filter : String, count : Int
        }
        var array : [pageCounter] = [.init(filter: "Later", count: 0), .init(filter: "Week", count: 0), .init(filter: "Today", count: 0)]
        var intermediarArray = [Task]()
        
        for i in 0..<3 {
            intermediarArray = Functions.SharedInstance.getData(key: userDefaultsSaveKey).filter({$0.due == array[i].filter})
            array[i].count = intermediarArray.count
        }
        
//        array.sort(by: {$0.count >= $1.count})
        print(array)
        
        for element in array.reversed() {
            if element.count > 0 {
                return element.filter
            }
        }
        return array[0].filter
    }
}
