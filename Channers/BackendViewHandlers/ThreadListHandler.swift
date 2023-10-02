//
//  ThreadListHandler.swift
//  Channers
//
//  Created by Rez on 5/24/23.
//
//  Handles lists of threads

import Foundation

import Foundation
import SwiftUI

///handles retreiving catalogs for views
class ThreadListHandler : ObservableObject {
    static var current = ThreadListHandler()
    //catalogs in memory are stored here
    private var storedLists = Cache<String, ThreadListObj>()
    
    ///Gets a catalog from the storage, loads the catalog if it doesn't already exist
    func LoadList(forBoard : String) -> ThreadListObj {
        if(!storedLists.containsKey(forBoard)) {
            storedLists[forBoard] = ThreadListObj(board: forBoard)
        }
        
        return storedLists[forBoard]!
    }
    
    ///fetches the data again for a given catalog
    func RefreshList(forBoard : String) {
        storedLists[forBoard] = ThreadListObj(board: forBoard)
    }
}
