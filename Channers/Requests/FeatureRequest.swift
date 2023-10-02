//
//  FeatureRequest.swift
//  Channers
//
//  Created by Rez on 4/13/23.
//

import Foundation
import SwiftUI

///Holds methods that request more specific data
///Requests from RequestMethod class
class FeatureRequest {
        
    ///Grabs the catalog page for a board that shows a catalog of posts in API form (an array)
    static func GrabCatalogAPI(ofBoard : String, onSuccess: @escaping (Catalog) -> (),
                           onFailure: @escaping (Error) -> ()) {
        let urlString = "https://\(domains.chanMain)/\(ofBoard)/catalog.json"
        let url = URL(string: urlString)
        DataRequest.GetObjectDataArray(fromURL: url!, ofType: CatalogPageRaw.self) {
            rawCatalogPages in
            onSuccess(Catalog(rawPages: rawCatalogPages, ofBoard: ofBoard))
        } onFailure: { reqError in
            onFailure(reqError)
        }
    }
    
    ///Grabs the page of boards and all the data on the boards
    static func GrabBoardsAPI(onSuccess: @escaping (PageOfBoards) -> (),
                          onFailure: @escaping (Error) -> ()) {
        let urlString = "https://\(domains.chanMain)/boards.json"
        let url = URL(string: urlString)
        DataRequest.GetObjectData(fromURL: url!, ofType: PageOfBoardsRaw.self) {
            rawBoards in
            
            
            onSuccess(PageOfBoards(rawBoards: rawBoards))
        } onFailure: { reqError in
            onFailure(reqError)
        }
    }
    
    ///Grabs the posts at an index for a given board
    static func GrabPostsAPI(ofBoard : String, atIndex : Int,
                          onSuccess: @escaping (BoardPageRaw) -> (),
                          onFailure: @escaping (Error) -> ()) {
        let urlString = "https://\(domains.chanMain)/\(ofBoard)/\(atIndex).json"
        let url = URL(string: urlString)
        DataRequest.GetObjectData(fromURL: url!, ofType: BoardPageRaw.self, onSuccess: {
            posts in
            onSuccess(posts)
        }, onFailure: { reqError in
            onFailure(reqError)
        })
        
    }
    
    ///Grabs all the threads on a board
    ///Processed into a threadlist instead of a raw
    static func GrabThreadsAPI(fromBoard : String,
                            onSuccess: @escaping (ThreadLists) -> (),
                            onFailure: @escaping (Error) -> ()) {
        let urlString = "https://\(domains.chanMain)/\(fromBoard)/threads.json"
        let url = URL(string: urlString)
        DataRequest.GetObjectDataArray(fromURL: url!, ofType: ThreadListPageRaw.self) {
            PageThreads in
            
            var processedThreadList = ThreadLists(pages: [])
            
            (0..<PageThreads.count).forEach({
                pageNum in
                
                var processedThreadPage = ThreadListPage(page: pageNum, threads: [])
                PageThreads[pageNum].threads.forEach({
                    rawThreadSimple in
                    
                    processedThreadPage.threads.append(ChanThreadSimple(no: rawThreadSimple.no, lastModifiedSeconds: rawThreadSimple.last_modified, replies: rawThreadSimple.replies))
                })
                processedThreadList.pages.append(processedThreadPage)
            })
            
            onSuccess(processedThreadList)
        } onFailure: { reqError in
            onFailure(reqError)
        }
    }
    
    ///grabs all thread data for a particular thread
    static func GrabThreadDataAPI(fromBoard : String, withID : Int,
                               onSuccess: @escaping (ChanThread) ->(),
                               onFailure : @escaping (Error) -> ()) {
        let urlString = "https://\(domains.chanMain)/\(fromBoard)/thread/\(String(withID)).json"
        print(urlString)
        let url = URL(string: urlString)
        DataRequest.GetObjectData(fromURL: url!, ofType: ChanThreadsRaw.self) {
            thread in
            
            var thread = thread
            let op = thread.posts.remove(at: 0)
            onSuccess(ChanThread(board: fromBoard, op: op, rawPosts: thread.posts))
        } onFailure: { reqError in
            onFailure(reqError)
        }
    }
}

///represents an error in grabbing an image from 4chan
enum ChanImageError : Error {
    case couldNotConvertDataToImg
    case imageNotFound
    case unknownError
}
