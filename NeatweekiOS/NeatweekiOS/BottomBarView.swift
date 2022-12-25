//
//  BottomBarView.swift
//  NeatweekiOS
//
//  Created by Mihnea on 12/25/22.
//

import SwiftUI

struct BottomBarView: View {
    @Binding var filter : String
    var body: some View {
        VStack{
            Divider()
            HStack {
                VStack{
                    Text("Later")
                        .onTapGesture {
                            withAnimation{
                                filter = "Later"
                            }
                        }
                    .bold()
                    .padding([.leading, .trailing])
                    .font(.title3)
                    if filter == "Later" {
                        Rectangle()
                            .frame(width: 50, height: 3)
                            .padding([.leading, .trailing, .bottom])
                    }
                }
                Spacer()
                VStack{
                    Text("Week")
                        .onTapGesture {
                            withAnimation{
                                filter = "Week"
                            }
                        }
                    .bold()
                    .padding([.leading, .trailing])
                    .font(.title3)
                    if filter == "Week" {
                        Rectangle()
                            .frame(width: 50, height: 3)
                            .padding([.leading, .trailing, .bottom])
                    }
                }
                Spacer()
                VStack{
                    Text("Today")
                        .onTapGesture {
                            withAnimation{
                                filter = "Today"
                            }
                        }
                    .bold()
                    .padding([.leading, .trailing])
                    .font(.title3)
                    if filter == "Today" {
                        Rectangle()
                            .frame(width: 50, height: 3)
                            .padding([.leading, .trailing, .bottom])
                    }
                    
                }
            }
        }
    }
}

struct BottomBarView_Previews: PreviewProvider {
    static var previews: some View {
        BottomBarView(filter: .constant("Later"))
    }
}
