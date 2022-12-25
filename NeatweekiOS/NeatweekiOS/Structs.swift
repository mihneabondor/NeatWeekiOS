//
//  Structs.swift
//  NeatweekiOS
//
//  Created by Mihnea on 12/25/22.
//

import Foundation
import SwiftUI


struct Task : Identifiable, Codable {
    var id = UUID()
    var text = ""
    var completed : Bool = false
    var due : String = "Later"
    var color : String = "white"
}

let userDefaultsSaveKey = "com.aoklabs.NeatweekiOS.tasks"
var tasks = Functions.SharedInstance.getData(key: userDefaultsSaveKey)
