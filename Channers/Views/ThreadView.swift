//
//  ThreadView.swift
//  Channers
//
//  Created by Rez on 4/18/23.
//

import SwiftUI

///Represents the view of an entire thread
struct ThreadView: View {
    @ObservedObject var thread : ThreadObj
    @EnvironmentObject var theme : ColorSettings
    @State var maxRepliesLoad : Int = 10
    @State var refreshed = false
    
    init(board : String, id : Int) {
        thread = ThreadHandler.current.LoadThread(forBoard: board, withID: id)
    }
    
    var body: some View {
        GeometryReader {
            geo in
            
            ScrollView() {
                if(thread.canShow) {
                    ThreadDisplay()
                        .navigationTitle(Text("/\(thread.board)/ - \(String(thread.threadData!.posts.count)) replies"))
                } else {
                    LoadingDisplay()
                        .frame(width: geo.size.width)
                        .frame(minHeight: geo.size.height)
                        .navigationTitle(Text("/\(thread.board)/"))
                }
            }
            .refreshable(action: {
                print("can show " + String(thread.canShow))
                thread.FetchData()
            })
        }
        .background(theme.background)
    }
    
    @ViewBuilder func ThreadDisplay() -> some View {
        VStack() {
            ThreadOP(thread.threadData!.op)
                .environmentObject(thread)
            if(!thread.threadData!.posts.isEmpty) {
                //Replies
                ForEach(thread.threadData!.posts[0..<min(maxRepliesLoad, thread.threadData!.posts.count)]) {
                    reply in
                    
                    ThreadReply(reply)
                        .environmentObject(thread)
                        .padding([.horizontal], 10)
                    
                }
                //only show more if the current last index is higher than reply count
                if(maxRepliesLoad < thread.threadData!.posts.count) {
                    Button(action: {
                        maxRepliesLoad += 10
                    }, label: {
                        Text("Load more :3")
                            .foregroundColor(theme.primary)
                            .frame(width: 300, height: 50)
                            .background(RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(theme.foreground))
                            .padding([.bottom], 10)
                    })
                }
            }
            else {
                Text("no comments :(((((((")
            }
        }
        
    }
    
    @ViewBuilder func LoadingDisplay() -> some View {
        VStack(alignment: .center) {
            Spacer()
            ProgressView()
                .progressViewStyle(.circular)
            Text("Loading thread...")
            Spacer()
        }
    }
}



struct ThreadView_Previews: PreviewProvider {
    static var previews: some View {
        ThreadViewDebug()
        
    }
}

struct ThreadViewDebug : View {
    var body : some View {
        TabView() {
            ThreadView(board: "lgbt", id: 31753271)
                .environmentObject(ColorSettings.current)
                .environmentObject(GeneralSettings.current)
                .navigationTitle("debug")
                .navigationBarTitleDisplayMode(.inline)
                .tabItem({Label("bruh", systemImage: "gear")})
        }
    }
}
