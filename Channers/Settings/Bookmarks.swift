//
//  Bookmarks.swift
//  Channers
//
//  Created by Rez on 6/5/23.
//

import Foundation

class Bookmarks : ObservableObject {
    static var shared = Bookmarks()
    private let bookmarkedThreadsKey = "bookmarkedThreadsKey"
    @Published private(set) var bookmarkedThreads : [String] {
        didSet {
            GeneralSettings.current.bookmarkedThreads = bookmarkedThreads
        }
    }
    
    init() {
        bookmarkedThreads = GeneralSettings.current.bookmarkedThreads
    }
    
    func addThread(onBoard board : String, withID id : Int) {
        let key = bookmarkKey(board, id)
        guard !bookmarkedThreads.contains(key) else {
            return
        }
        
        bookmarkedThreads.append(bookmarkKey(board, id))
    }
    
    func removeThread(onBoard board : String, withID id : Int) {
        let key = bookmarkKey(board, id)
        guard let index = bookmarkedThreads.firstIndex(of: key) else {
            return
        }
        
        bookmarkedThreads.remove(at: index)
    }
    
    func containsThread(onBoard board : String, withID id : Int) -> Bool {
        return bookmarkedThreads.firstIndex(of: bookmarkKey(board, id)) != nil
    }
    
    private func bookmarkKey(_ board : String, _ id : Int) -> String {
        "\(board)_\(id)"
    }
}
