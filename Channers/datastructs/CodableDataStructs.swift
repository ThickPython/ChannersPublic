//
//  Threads.swift
//  Channers
//
//  Created by Rez on 4/12/23.
//
//  Basic data structs used by 4chan


import Foundation
import SwiftUI

struct ChanPostID: Codable, Identifiable {
    var id = UUID()
    var post : ChanPostRaw
}

//https://github.com/4chan/4chan-API/blob/master/pages/Catalog.md
//Raw chan post, no ID, kinda cringe
struct ChanPostRaw: Codable {
    var id : UUID? = UUID()
    
    //Always will appear
    var no: Int?
    var resto: Int?
    var now: String?
    var time: Int?
    var name: String?
    
    //sometimes
    var com : String?
    var sub : String? 
    
    //Attachment only
    var tim: Int?
    var filename: String?
    var ext: String?
    var fsize: Int?
    var md5: String?
    var w: Int?
    var h: Int?
    var tn_w: Int?
    var tn_h: Int?
    var filedeleted: Int?
    var spoiler: Int?
    var custom_spoiler: Int?
    
    //op only
    var sticky : Int?
    var closed : Int?
    var omitted_posts: Int?
    var omitted_images: Int?
    var replies: Int?
    var images: Int?
    var bumplimit: Int?
    var imagelimit: Int?
    var last_modified: Int?
    var tag: String?
    var semantic_url: String?
    var since4pass: Int?
    var unique_ips: Int?
    var m_img: Int?
    var last_replies: [ChanPostRaw]?
}

///Raw catalog page with raw chan posts
struct CatalogPageRaw : Codable {
    var page : Int
    var threads : [ChanPostRaw]?
}


//https://github.com/4chan/4chan-API/blob/master/pages/Boards.md

///Represents the page that shows all the boards
struct PageOfBoardsRaw : Codable{
    var boards : [ChanBoardRaw]
}

///Raw 4chan board data 
struct ChanBoardRaw : Codable {
    var board : String
    var title : String
    var ws_board : Int
    var per_page : Int
    var pages : Int
    var max_filesize : Int
    var max_webm_filesize : Int
    var max_comment_chars : Int
    var max_webm_duration : Int
    var bump_limit : Int
    var image_limit : Int
    //var cooldowns : [?]
    var meta_description : String
    var spoilers : Int?
    var custom_spoilers : Int?
    var is_archived : Int?
    //var board_flag : Array
    var country_flags : Int?
    var user_ids : Int?
    var oekaki : Int?
    var sjis_tags : Int?
    var code_tags : Int?
    var math_tags : Int?
    var text_only : Int?
    var forced_anon : Int?
    var webm_audio : Int?
    var require_subject : Int?
    var min_image_width : Int?
    var min_image_height : Int?
}



//https://github.com/4chan/4chan-API/blob/master/pages/Indexes.md
///Represents a page of a board that shows threads
struct BoardPageRaw : Codable  {
    var threads : [BoardPagePosts]
}

struct BoardPagePosts : Codable {
    var posts : [ChanPostRaw]
}

//https://github.com/4chan/4chan-API/blob/master/pages/Threadlist.md


//Represents a page on a board and the basic thread details it has.
//Kinda like boardpageposts but smaller
struct ThreadListPageRaw : Codable {
    var page : Int
    var threads : [ChanThreadSimpleRaw]
}

//represents a chan thread but only the basic details of it
struct ChanThreadSimpleRaw : Codable {
    ///OP ID of thread
    var no : Int
    ///Unix timestamp
    var last_modified : Int
    ///Number of replies
    var replies : Int
}

//https://github.com/4chan/4chan-API/blob/master/pages/Threads.md
///Represents an entire chan thread where the OP is the top and the rest are replies
struct ChanThreadsRaw : Codable {
    var posts : [ChanPostRaw]
}


