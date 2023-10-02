//
//  BookmarkButton.swift
//  Channers
//
//  Created by Rez on 6/4/23.
//

import SwiftUI

struct BookmarkButton: View {
    @EnvironmentObject var theme : ColorSettings
    @State var isBookmarked : Bool
    var icon : String {
        isBookmarked ? "bookmark.fill" : "bookmark"
    }
    var board : String
    var threadID : Int
    
    init(board : String, threadID : Int) {
        isBookmarked = Bookmarks.shared.containsThread(onBoard: board, withID: threadID)
        self.board = board
        self.threadID = threadID
    }
    
    var body: some View {
        Button(action: {
            if(!isBookmarked) {
                Bookmarks.shared.addThread(onBoard: board, withID: threadID)
            } else {
                Bookmarks.shared.removeThread(onBoard: board, withID: threadID)
            }
            isBookmarked = Bookmarks.shared.containsThread(onBoard: board, withID: threadID)
        }, label: {
            Label("bookmark", systemImage: icon)
                .labelStyle(.iconOnly)
                .font(.title3)
                .tint(theme.accent)
        })
    }
}

struct BookmarkButton_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkButton(board: "b", threadID: 3153)
            .environmentObject(ColorSettings.current)
    }
}
