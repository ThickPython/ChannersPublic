//
//  BookmarkedThreadsView.swift
//  Channers
//
//  Created by Rez on 6/5/23.
//

import SwiftUI

struct BookmarkedThreadsView: View {
    @EnvironmentObject var bookmarkedPath : NavPathHandler
    @EnvironmentObject var theme : ColorSettings
    @ObservedObject var bookmarkManager = Bookmarks.shared
    
    var body: some View {
        NavigationStack(path: $bookmarkedPath.path) {
            if(!bookmarkManager.bookmarkedThreads.isEmpty) {
                ScrollView {
                    ForEach(bookmarkManager.bookmarkedThreads.reversed(), id: \.self) { threadString in
                        
                        threadOPPreview(board: threadString.components(separatedBy: "_")[0],
                                        threadID: Int(threadString.components(separatedBy: "_")[1])!)
                        
                    }
                }
                .padding(10)
                .background(theme.background)
                .navigationTitle("Bookmarks")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: Threadloader.self, destination: {
                    loader in
                    
                    ThreadView(board: loader.board, id: loader.postID)
                })
                .navigationDestination(for: BoardLoader.self, destination: {
                    loader in
                    
                    BoardContentView(board: loader.board)
                })
            } else {
                ZStack() {
                    Rectangle()
                    Label("No bookmarks", systemImage: "note")
                }
            }
        }
    }
    
    struct threadOPPreview: View {
        @ObservedObject var thread : ThreadObj
        var board : String
        var threadID : Int
        
        init(board: String, threadID: Int) {
            self.board = board
            self.threadID = threadID
            thread = ThreadHandler.current.LoadThread(forBoard: board, withID: threadID)
        }
        
        var body: some View {
            if(thread.canShow) {
                PostPreview(OPPost: thread.threadData!.op, previewStyle: GeneralSettings.current.defaultPostPreview)
            } else {
                Text("Loading bookmark post")
            }
        }
    }
}

struct BookmarkedThreadsView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkedThreadsViewDebug()
    }
}

struct BookmarkedThreadsViewDebug : View {
    var body : some View {
        BookmarkedThreadsView()
            .environmentObject(ColorSettings.current)
            .environmentObject(NavPathHandler())
            
    }
}
