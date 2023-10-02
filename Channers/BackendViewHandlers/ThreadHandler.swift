//
//  ThreadHandler.swift
//  Channers
//
//  Created by Rez on 4/21/23.
//

import Foundation

class ThreadHandler : ObservableObject {
    static var current = ThreadHandler()
    //threads in memory are stored here
    private var storedThreads = Cache<String, ThreadObj>()
    
    ///gets a thread obj with associated board and id
    func LoadThread(forBoard : String, withID : Int) -> ThreadObj {
        let threadKey = GetThreadKey(forBoard, withID)
        if(!storedThreads.containsKey(threadKey)) {
            print("new thread")
            storedThreads[threadKey]
                = ThreadObj(board: forBoard, postID: withID)
        }
        return storedThreads[threadKey]! //handle if it's not there here
    }
    
    ///refreshes a thread for a given board and id
    func RefreshThread(forBoard : String, withID : Int) {
        guard storedThreads.containsKey(GetThreadKey(forBoard, withID)) else {
            return
        }
        
        storedThreads[GetThreadKey(forBoard, withID)]!.FetchData()
    }
    
    private func GetThreadKey(_ board: String, _ id: Int) -> String {
        return board + String(id)
    }
}


