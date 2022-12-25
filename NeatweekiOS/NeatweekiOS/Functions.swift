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
}
