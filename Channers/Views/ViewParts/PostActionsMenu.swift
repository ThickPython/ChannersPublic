//
//  PostActionsMenu.swift
//  Channers
//
//  Created by Rez on 7/2/23.
//

import SwiftUI

///The three dots you see and then you click on it and get this menu
struct PostActionsMenu: View {
    @EnvironmentObject var theme : ColorSettings
    private var shareLink : URL?
    private var shareSubject : String?
    private var shareComment : String?
    private var shareImage : Image?
    private var shareImageLink : URL?
    
    ///oppost of the thread
    private var bookmarkThread : ChanPost?
    private var menuLabel : any View
    
    init(label : some View =
         Label("Menu", systemImage: "ellipsis")
            .labelStyle(.iconOnly)
            .foregroundColor(.primary)
    ) {
        menuLabel = label
    }
    
    var body: some View {
        Menu() {
            Text("menu!")
            if(shareLink != nil) {
                ShareLink(item: shareLink!) {
                    Label("Share Link", systemImage: "square.and.arrow.up")
                }
            }
            if(shareSubject != nil) {
                Button(action: {
                    UIPasteboard.general.string = shareSubject!
                }, label: {
                    Label("Copy Subject", systemImage: "doc.on.doc")
                })
            }
            if(shareComment != nil) {
                Button(action: {
                    UIPasteboard.general.string = shareComment!
                }, label: {
                    Label("Copy Comment", systemImage: "doc.on.doc")
                })
            }
            if(shareImage != nil) {
                ShareLink(item: shareImage!,
                          preview: SharePreview("Preview image", image: shareImage!),
                          label: {
                    Label("Share Image", systemImage: "square.and.arrow.up")
                })
            }
            if(shareImageLink != nil) {
                ShareLink(item: shareLink!) {
                    Label("Share Image Link", systemImage: "square.and.arrow.up")
                }
            }
            if(bookmarkThread != nil) {
                let board = bookmarkThread!.board
                let no = bookmarkThread!.rawData.no!
                
                if(!Bookmarks.shared.containsThread(onBoard: board, withID: no)) {
                    Button(action: {
                        Bookmarks.shared.addThread(onBoard: board, withID: no)
                    }, label: {
                        Label("Bookmark Thread", systemImage: "bookmark")
                    })
                } else {
                    Button(action: {
                        Bookmarks.shared.removeThread(onBoard: board, withID: no)
                    }, label: {
                        Label("Remove Bookmark", systemImage: "bookmark.slash")
                    })
                }
            }
            
        } label: {
            AnyView(menuLabel)
        }
    }
    
    @inlinable func sharePostLink(is linkStr : String) -> PostActionsMenu {
        guard let url = URL(string: linkStr) else {
            return self
        }
        var newer = self
        newer.shareLink = url
        return newer
    }
    
    @inlinable func shareSubject(is subject : String?) -> PostActionsMenu {
        guard let subject = subject else {
            return self
        }
        
        var newer = self
        newer.shareSubject = subject
        return newer
    }
    
    @inlinable func shareComment(is comment : String?) -> PostActionsMenu {
        guard let comment = comment else {
            return self
        }
        
        var newer = self
        newer.shareComment = comment
        return newer
    }
    
    @inlinable func shareImage(is image : Image?) -> PostActionsMenu {
        guard let image = image else {
            return self
        }
        
        var newer = self
        newer.shareImage = image
        return newer
    }
    
    @inlinable func shareImageLink(is imageUrl : String?) -> PostActionsMenu {
        guard let imageUrl = imageUrl else {
            return self
        }
        
        guard let imageUrl = URL(string: imageUrl) else {
            return self
        }
        
        var newer = self
        newer.shareImageLink = imageUrl
        return newer
    }
    
    @inlinable func bookmarkableThread(opPost : ChanPost?) -> PostActionsMenu {
        guard let opPost = opPost else {
            return self
        }
        
        var newer = self
        newer.bookmarkThread = opPost
        return newer
    }
}

struct PostActionsMenu_Previews: PreviewProvider {
    static var previews: some View {
        PostActionsMenu()
            .sharePostLink(is: "https://developer.apple.com/xcode/swiftui/")
            .shareComment(is: "comment")
            .shareImage(is: Image("cuteboy"))
            .labelStyle(.iconOnly)

    }
}
