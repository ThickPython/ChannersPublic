//
//  NavpathManager.swift
//  Channers
//
//  Created by Rez on 4/21/23.
//

import Foundation
import SwiftUI

///Manages the navigation path for the home page
class NavPathHandler : ObservableObject {
    @Published var path = NavigationPath()
    
    init() {
        
    }
    
    func gotoHomePage() {
        path.removeLast(path.count)
    }
    
    ///opens a thread by appending it to the nav path
    func openThread(fromBoard : String, withID : Int) {
        path.append(Threadloader(board: fromBoard, postID: withID))
    }
    
    ///opens a catalog by appending it to the nav path
    func openCatalog(forBoard : String) {
        path.append(BoardLoader(board: forBoard))
    }
}

enum ViewLoadType : Hashable {
    case Thread
    case Catalog
}

///Passed to a navigation path by the navpathhandler  to load a threadview
struct Threadloader : Hashable {
    static func == (lhs: Threadloader, rhs: Threadloader) -> Bool {
        return ((lhs.board == rhs.board) && (lhs.postID == rhs.postID))
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(board)
        hasher.combine(postID)
    }
    
    var board : String
    var postID : Int
}

struct BoardLoader : Hashable {
    static func == (lhs : BoardLoader, rhs: BoardLoader) -> Bool {
        return (lhs.board == rhs.board)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(board)
    }
    
    var board : String
}

