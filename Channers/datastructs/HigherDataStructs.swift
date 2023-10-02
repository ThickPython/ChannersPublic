//
//  HigherDataStructs.swift
//  Channers
//
//  Created by Rez on 4/13/23.
//
//  Higher level data structs for ease of use
//  Layer of abstraction around 4chans codable structs
//  Includes helper methods

import Foundation
import SwiftUI

///Represents an entire catalog of a board
struct Catalog  {
    var pages : [CatalogPage]
    var board : String
    
    init(rawPages: [CatalogPageRaw], ofBoard : String) {
        board = ofBoard
        pages = []
        for rawPage in rawPages {
            var newPage = CatalogPage(page: rawPage.page, threads: [])
            
            guard rawPage.threads != nil else{
                continue
            }
            
            for rawPost in rawPage.threads! {
                newPage.threads.append(ChanPost(raw: rawPost, onBoard: ofBoard))
            }
            pages.append(newPage)
        }
    }
    
    func GetAllPagesAsOne() -> [ChanPost] {
        var allPosts : [ChanPost] = []
        
        for page in pages {
            for post in page.threads {
                allPosts.append(post)
            }
        }
        
        return allPosts
    }
}

///Represents a page in a catalog
struct CatalogPage {
    var page : Int
    var threads : [ChanPost]
}

///Represents a page of boards that hold all 4chan board data
struct PageOfBoards {
    var boards : [ChanBoard]
    var sfwBoards : [ChanBoard]
    
    init(rawBoards : PageOfBoardsRaw) {
        self.boards = []
        self.sfwBoards = []
        
        for rawBoard in rawBoards.boards {
            boards.append(ChanBoard(raw: rawBoard))
            if(!AppConsts.nsfwForums.contains(rawBoard.board)) {
                sfwBoards.append(ChanBoard(raw: rawBoard))
            }
        }
    }
    
    func GetBoards(alphabetical : Bool, nsfw : Bool) -> [ChanBoard] {
        print(nsfw)
        var boards = nsfw ? boards : sfwBoards
        if !alphabetical {
            boards = boards.reversed()
        }
        
        return boards
    }
}

///Represents a board and all the threads on all of the pages
struct ThreadListRaw : Codable {
    var pages : [ThreadListPageRaw]
}

///Represents a chan thread and all it's posts
struct ChanThread {
    var board : String
    var op : ChanPost
    var posts : [ChanPost]
    var postIndex : [Int : ChanPost]
    
    init(board: String, op : ChanPostRaw, rawPosts : [ChanPostRaw]) {
        self.board = board
        self.posts = []
        self.postIndex = [:]
        self.op = ChanPost(raw: op, onBoard: board)
        
        for rawPost in rawPosts {
            posts.append(ChanPost(raw: rawPost, onBoard: board))
            postIndex[rawPost.no!] = ChanPost(raw: rawPost, onBoard: board)
        }
    }
    
    ///returns the subject of the OPPost if it exists
    func GetThreadSubject() -> String? {
        return posts[0].GetSubject() == "" ? nil : posts[0].GetSubject()
    }
}

///Abstract layer over a raw 4chan post with helper functions
class ChanPost : ObservableObject, Identifiable {
    @Published var hdAttachmentLoaded : Bool
    @Published var tnAttachmentLoaded : Bool
    var commentView : CommentViewHandler
    var board : String //board it belongs to
    var rawData : ChanPostRaw
    var replies : [ChanPost]
    var id = UUID()
    var hasAttachment : Bool { return rawData.tim != nil }
    var hdAttachment : UIImage? { didSet { hdAttachmentLoaded = true } }
    var tnAttachment : UIImage? { didSet { tnAttachmentLoaded = true } }
    
    init(raw : ChanPostRaw, onBoard : String) {
        hdAttachmentLoaded = false
        tnAttachmentLoaded = false
        rawData = raw
        board = onBoard
        replies = []
        commentView = CommentViewHandler(comment: rawData.com ?? "")
        
        guard rawData.last_replies != nil else {
            return
        }
        
        for rawReply in rawData.last_replies! {
            replies.append(ChanPost(raw: rawReply, onBoard: board))
        }
    }
    
    ///Loads the attachment for this post, if it exists
    func LoadHDAttachment() {
        guard hasAttachment && hdAttachment == nil else {
            return
        }
        
        FeatureHandlers.GetChanImage(GetHDImageData()!) {
            img in
            
            DispatchQueue.main.async {
                self.hdAttachment = img
            }
        } onFailure: { error in
            DispatchQueue.main.async {
                self.hdAttachment = UIImage(named: "imageFail")
            }
        }
    }
    
    func LoadTNAttachment() {
        guard hasAttachment && tnAttachment == nil else {
            return
        }
        
        FeatureHandlers.GetChanImage(GetTNImageData()!) {
            img in
            
            DispatchQueue.main.async {
                self.tnAttachment = img
            }
        } onFailure: { error in
            if error is ChanImageError &&
                error as! ChanImageError == ChanImageError.imageNotFound {
                print("TN image not found, falling back to HD")
                ///assume that perhaps the thumbnail image does not exist
                ///and that there is only a normal hd image
                FeatureHandlers.GetChanImage(self.GetHDImageData()!, onSucess: {
                    img in
                    
                    DispatchQueue.main.async {
                        self.hdAttachment = img
                        self.tnAttachment = img
                    }
                }, onFailure: { ///if the hd image doesn't even exist then the image is just messed for this post
                    img in
                    
                    DispatchQueue.main.async {
                        self.hdAttachment = UIImage(named: "imageFail")
                        self.tnAttachment = UIImage(named: "imageFail")
                    }
                })
            }
            else {
                print("Failure to get image with error \(error)")
            }
        }
    }
    
    //load the comment text view
    @ViewBuilder func GetCommentTextView() -> some View {
        commentView.textView()
    }
    
    //load the comment view
    @ViewBuilder func GetCommentView() -> some View {
        commentView.commentView()
    }
    
    
    ///Returns the date posted
    func GetDatePosted() -> Date {
        return (NSDate(timeIntervalSince1970: TimeInterval(rawData.time ?? 0)) as Date)
    }
    
    //Returns empty "" if there is no subject
    func GetSubject() -> String {
        return (rawData.sub ?? "").removingHTMLEntities()
    }
    
    //Gets the url of the post
    func GetPostURL() -> String {
        //resto is no of thread replied to, 0 if OP
        if(rawData.resto! == 0) {
            return "https://boards.4channel.org/\(board)/thread/\(rawData.no!)"
        } else {
            return "https://boards.4channel.org/\(board)/thread/\(rawData.resto!)#p\(rawData.no!)"
        }
    }
    
    ///Gets the url of the image, returns "" if there is no image
    func GetImageURL() -> String {
        guard let imageData = GetHDImageData() else {
            return ""
        }
        
        return imageData.urlStr
    }
    
    ///Returns the file name for the image
    ///CRASHES IF YOU DON'T CHECK IF THE FILE NAME EXISTS
    func GetFileName() -> String {
        return rawData.filename! + rawData.ext!
    }
    
    ///Gets the HD image data as a chanimagedata struct
    ///Returns null if there is no attachment
    func GetHDImageData() -> ChanImageData? {
        guard hasAttachment else {
            return nil
        }
        
        return ChanImageData(width: rawData.w!,
                      height: rawData.h!,
                      board: board,
                      postID: rawData.no!,
                      serverFileName: "\(rawData.tim!)",
                      fileName: rawData.filename!,
                      fileExt: rawData.ext!)
    }
    
    ///Gets the TN image data as a chanimagedata struct
    ///Returns null if there is no attachment
    func GetTNImageData() -> ChanImageData? {
        guard hasAttachment else {
            return nil
        }
        
        return ChanImageData(width: rawData.tn_w!,
                      height: rawData.tn_w!,
                      board: board,
                      postID: rawData.no!,
                      serverFileName: "\(rawData.tim!)s",
                      fileName: rawData.filename!,
                      //fileExt: rawData.ext!
                      fileExt: ".jpg" //tn images are always jpg
        )
    }
}

///Abstract layer over a raw 4chan board with helper functions
class ChanBoard : ObservableObject, Identifiable, Hashable {
    static func == (lhs: ChanBoard, rhs: ChanBoard) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawData.board)
    }
    
    var id = UUID()
    var rawData : ChanBoardRaw
    
    init(raw : ChanBoardRaw) {
        self.rawData = raw
    }
}


///Represents a set of threadlists for a board
struct ThreadLists {
    var pages : [ThreadListPage]
}

///Represents a threadlist
struct ThreadListPage : Identifiable {
    var id = UUID()
    
    var page : Int
    var threads : [ChanThreadSimple]
}

///Represents a simple chanthread containing basic data
struct ChanThreadSimple : Identifiable {
    var id = UUID()
    
    ///OP ID of thread
    var no : Int
    ///Unix timestamp
    var lastModifiedSeconds : Int
    ///Number of replies
    var replies : Int
    
    ///Represents the last modified date of the thread
    var lastModifiedDate : Date {
        Date(timeIntervalSince1970: TimeInterval(lastModifiedSeconds))
    }
    
    ///Returns a time interval representing the time since the post was edited and now
    var timeSinceEdit : TimeInterval {
        lastModifiedDate.timeIntervalSinceNow
    }
}

