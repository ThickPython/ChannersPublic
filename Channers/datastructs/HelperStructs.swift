//
//  File.swift
//  Channers
//
//  Created by Rez on 4/24/23.
//

import Foundation

///A struct that contains data about a 4chan image
struct ChanImageData {
    var width : Int
    var height : Int
    var board : String
    var postID : Int
    ///filename on the server (s)tim
    var serverFileName : String
    var fileName : String
    ///Includes the dot
    var fileExt : String
    
    var urlStr : String {
       "https://\(domains.chanMedia)/\(board)/\(serverFileName)\(fileExt)"
    }
}
