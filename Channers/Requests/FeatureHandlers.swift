//
//  FeatureRequestHandlers.swift
//  Channers
//
//  Created by Rez on 4/13/23.
//
//  A collection of functions to help you get your features
//  Grabs from feature request

import Foundation
import SwiftUI


///Obj that contains and gets the catalog page for a board
class CatalogObj : ObservableObject {
    let INITIAL_LOAD_IMAGES = 4 //initially load 5 images
    @Published var canDisplay : Bool = false
    var board : String = ""
    var data : Catalog? = nil {
        didSet {
            canDisplay = true
        }
    }
    
    init(board: String) {
        self.board = board
        GetObj()
    }
    
    func GetObj() {
        canDisplay = false
        FeatureHandlers.GetCatalog(fromBoard: board) { [self]
            catalog in
            
            DispatchQueue.main.async {
                self.data = catalog
            }
        } onFailure: { error in
            
        }
    }    
}

///Obj that contains and gets all the boards on 4chan
class BoardsObj : ObservableObject {
    @Published var canDisplay : Bool
    var data : PageOfBoards? = nil {
        didSet {
            canDisplay = data != nil
        }
    }
    
    init() {
        canDisplay = false
        GetObj()
    }
    
    private func GetObj() {
        FeatureHandlers.GetBoards() { [self]
            boards in
            
            DispatchQueue.main.async {
                self.data = boards
            }
        } onFailure: { error in
            print(error)
            print("failed to fetch boards")
        }
    }
    
    func refreshData() {
        GetObj()
    }
}

///Obj that contains and gets all the page on a board
class BoardPagePostsObj : ObservableObject {
    var board : String = ""
    var page : Int = 0
    @Published var posts : BoardPageRaw? = nil
    
    init(board: String, page: Int) {
        self.board = board
        self.page = page
        
        GetObj()
    }
    
    func GetObj() {
        FeatureHandlers.GetPosts(fromBoard: board, onPage: page) { [self]
            posts in
            
            DispatchQueue.main.async {
                self.posts = posts
            }
        } onFailure: { error in
            return
        }
    }
}

///Obj that contains and gets all the threads on a board
///https://github.com/4chan/4chan-API/blob/master/pages/Threadlist.md
class ThreadListObj : ObservableObject {
    var board : String = ""
    @Published var canDisplay : Bool = false
    var threads : ThreadLists? = nil {
        didSet {
            canDisplay = true
        }
    }
    var id = UUID()
    
    init(board: String) {
        self.board = board
        GetObj()
    }
    
    func GetObj() {
        FeatureRequest.GrabThreadsAPI(fromBoard: board, onSuccess: {
            threadlists in
            
            DispatchQueue.main.async {
                self.threads = threadlists
            }
        }, onFailure: {
            error in
            
            print("Failed to get threadlist \(error)")
        })
    }
}

///Obj that contains and gets all the replies on a thread on a board
class ThreadObj : ObservableObject {    
    var board : String = ""
    
    ///op number, or thread id
    var postID : Int = 0
    @Published var canShow : Bool = false
    var threadData : ChanThread? = nil {
        didSet {
            canShow = true
        }
    }
    
    init(board: String, postID: Int) {
        self.board = board
        self.postID = postID
        FetchData()
    }
    
    func FetchData() {
        canShow = false
        FeatureRequest.GrabThreadDataAPI(fromBoard: board, withID: postID, onSuccess: {
            thread in
            
            DispatchQueue.main.async {
                self.threadData = thread
            }
        }, onFailure: {
            error in
            
            print("Error with message \(error)")
        })
    }
}

class FeatureHandlers {
    
    ///Tries to get a chan image with chan image data
    static func GetChanImage(_ data : ChanImageData,
                             onSucess: @escaping (UIImage) -> (),
                             onFailure: @escaping (Error) -> ()) {
        ImageCache.current.loadChannerImage(imageData: data, onCompletion: {
            image in
            
            onSucess(image)
        }, onFailure: { error in
            onFailure(error)
        })
    }
    
    ///Tries to get the catalog (high level)
    static func GetCatalog(fromBoard : String,
                           onSuccess: @escaping (Catalog) -> (),
                           onFailure: @escaping (Error) -> ()) {
        let reqParams = requestParameters(fromBoard: fromBoard)
            LoopGetData(withParams: reqParams,
                    forType: Catalog.self) {
            catalog in
            onSuccess(catalog)
        } onFailure: { error in
            onFailure(error)
        }
    }
    
    ///Tries to get the boards (high level)
    static func GetBoards(onSucess: @escaping (PageOfBoards) -> (),
                          onFailure: @escaping (Error) ->()) {
        let reqParams = requestParameters()
        LoopGetData(withParams: reqParams,
                    forType: PageOfBoards.self) {
            boards in
            onSucess(boards)
        } onFailure: { error in
            onFailure(error)
        }
    }
    
    ///Tries to get the boards (high level)
    static func GetPosts(fromBoard: String, onPage : Int,
                         onSucess: @escaping (BoardPageRaw) -> (),
                         onFailure: @escaping (Error) ->()) {
        let reqParams = requestParameters(fromBoard: fromBoard, boardPage: onPage)
        LoopGetData(withParams: reqParams,
                    forType: BoardPageRaw.self) {
            boardposts in
            onSucess(boardposts)
        } onFailure: { error in
            onFailure(error)
        }
    }
    
    ///Tries to get all the threads on a board (high level)
    static func GetThreadList(fromBoard : String,
                           onSucess: @escaping (ThreadLists) -> (),
                           onFailure: @escaping (Error) ->()) {
        let reqParams = requestParameters(fromBoard: fromBoard)
        LoopGetData(withParams: reqParams,
                    forType: ThreadLists.self) {
            threads in
            onSucess(threads)
        } onFailure: { error in
            onFailure(error)
        }
    }
    
    ///Tries to get all the data from a thread (high level)
    static func GetThread(fromBoard : String, withID: Int,
                          onSucess: @escaping (ChanThread) -> (),
                          onFailure: @escaping (Error) ->()) {
        let reqParams = requestParameters(fromBoard: fromBoard, postID: withID)
        LoopGetData(withParams: reqParams,
                    forType: ChanThread.self) {
            thread in
            onSucess(thread)
        } onFailure: { error in
            onFailure(error)
        }
    }
    
    
    //function that runs a timer and attempts to get data for a set amount of time
    //Before giving up
    static func LoopGetData<T>(withParams : requestParameters, forType : T.Type,
                                       maxAttempts : Int = 10,
                                        onSuccess : @escaping (T) -> (),
                                        onFailure : @escaping (Error) ->()) {
        switch forType {
            
        case is Catalog.Type:
            FeatureRequest.GrabCatalogAPI(ofBoard: withParams.fromBoard!) {
                catalog in
                onSuccess(catalog as! T)
            } onFailure: {
                error in onFailure(error)
            }
            
        case is PageOfBoards.Type:
            FeatureRequest.GrabBoardsAPI() {
                boards in
                onSuccess(boards as! T)
            } onFailure: {
                error in onFailure(error)
            }
        
        case is BoardPageRaw.Type:
            FeatureRequest.GrabPostsAPI(ofBoard: withParams.fromBoard!,
                                        atIndex: withParams.boardPage!) {
                boardPage in
                onSuccess(boardPage as! T)
            } onFailure : {
                error in onFailure(error)
            }
        
        case is ThreadLists.Type:
            FeatureRequest.GrabThreadsAPI(fromBoard: withParams.fromBoard!) {
                threads in
                
                onSuccess(threads as! T)
            } onFailure: {
                error in onFailure(error)
                
            }
            
        case is ChanThread.Type:
            FeatureRequest.GrabThreadDataAPI(fromBoard: withParams.fromBoard!,
                                             withID: withParams.postID!) {
                thread in
                onSuccess(thread as! T)
            } onFailure: {
                error in onFailure(error)
                
            }
        default:
            break
            //ok this should never happen but add a handling at some point anyways
        
        }
    }
    
    struct requestParameters {
        var fromBoard : String?
        var boardPage : Int?
        var postID : Int?
    }
}

