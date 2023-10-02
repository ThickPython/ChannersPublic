//
//  BoardHandler.swift
//  Channers
//
//  Created by Rez on 4/21/23.
//

import Foundation

class BoardsHandler : ObservableObject {
    @Published var allBoards : BoardsObj?
    static var current = BoardsHandler()
    
    ///Loads in boards if boards don't exist
    func LoadBoards() {
        if(allBoards == nil) {
            RefreshBoards()
        }
    }
    
    ///Forceably pulls new boards
    func RefreshBoards() {
        allBoards = BoardsObj()
    }
}
