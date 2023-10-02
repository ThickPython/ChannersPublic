//
//  ThreadListView.swift
//  Channers
//
//  Created by Rez on 5/24/23.
//

import SwiftUI

struct ThreadListView: View {
    @ObservedObject var threadList : ThreadListObj
    @State var pagesToLoad = 1
    var formatter : DateFormatter
    var intervalFormatter : DateComponentsFormatter
    var gridItems = [GridItem(.flexible()), GridItem(.flexible())]
    
    init(board : String) {
        self.threadList = ThreadListHandler.current.LoadList(forBoard: board)
        formatter = DateFormatter()
        formatter.timeStyle = .short
        intervalFormatter = DateComponentsFormatter()
        intervalFormatter.allowedUnits = [.day, .hour, .minute, .second]
        intervalFormatter.unitsStyle = .abbreviated
        
    }
    
    var body: some View {
        ScrollView() {
            if(threadList.canDisplay) {
                LazyVGrid(columns: gridItems) {
                    ForEach((0..<1), id: \.self) { num in
                        ForEach((threadList.threads?.pages[num].threads)!) { thread in
                            SimpleThreadPreview(thread)
                        }
                    }
                }
            } else {
                VStack() {
                    
                    Text("bruhfail")
                        .onTapGesture {
                            pagesToLoad += 1
                        }
                    Text(String(threadList.threads != nil))
                    Text(String(threadList.id.uuidString))
                }
                .onAppear(perform: {
                    print("appeared")
                })
            }
        }
    }
    
    @ViewBuilder func SimpleThreadPreview(_ thread : ChanThreadSimple) -> some View {
        VStack() {
            HStack() {
                Text(String(thread.no))
                Spacer()
            }
            
            HStack() {
                Label("\(thread.replies)", systemImage: "message")
                    .labelStyle(.titleAndIcon)
                Spacer()
                Divider()
                Spacer()
                Text("\(intervalFormatter.string(from: thread.lastModifiedDate, to: Date.now) ?? "?")")
                    .lineLimit(0)
            }
            
        }
        .padding([.horizontal], 20)
        .padding([.vertical], 10)
        .background(RoundedRectangle(cornerRadius: 15)
            .foregroundColor(Color(UIColor.systemGray6)))
        
    }
}

struct ThreadListView_Previews: PreviewProvider {
    static var previews: some View {
        ThreadListView(board: "lgbt")
    }
}
