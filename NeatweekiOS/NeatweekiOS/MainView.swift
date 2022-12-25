//
//  MainView.swift
//  NeatweekiOS
//
//  Created by Mihnea on 12/25/22.
//

import Foundation
import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            ListView(filter: "Later")
                .tabItem {
                    Label("Later", systemImage: "arrow.right")
                }

            ListView(filter: "Week")
                .tabItem {
                    Label("Week", systemImage: "arrow.right.to.line")
                }
            
            ListView(filter: "Today")
                .tabItem {
                    Label("Today", systemImage: "arrow.down")
                }
        }
    }
}
