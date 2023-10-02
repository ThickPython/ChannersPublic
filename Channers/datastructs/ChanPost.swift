//
//  ChanPost.swift
//  Channers
//
//  Created by Colin Deng on 5/19/23.
//
//  Represents a chan post and helper methods

import Foundation
import UIKit
import SwiftUI

///Abstract layer over a raw 4chan post with helper functions
class ChanPost : ObservableObject, Identifiable {
    @Published var hdAttachmentLoaded : Bool
    @Published var tnAttachmentLoaded : Bool
    var commentTextView : Text?
    
    
    var board : String //board it belongs to
    var rawData : ChanPostRaw
    var replies : [ChanPost]
    var hasAttachment : Bool {
        return rawData.tim != nil
    }
    var id = UUID()
    
    init(raw : ChanPostRaw, onBoard : String) {
        hdAttachmentLoaded = false
        tnAttachmentLoaded = false
        rawData = raw
        board = onBoard
        replies = []
        
        guard rawData.last_replies != nil else {
            return
        }
        
        for rawReply in rawData.last_replies! {
            replies.append(ChanPost(raw: rawReply, onBoard: board))
        }
    }
    
    ///Completes with the uiimage of the hdattachment if it exists
    ///nil if not
    func GetHDAttachment(onCompletion: @escaping (UIImage?) -> ()) {
        guard let imageData = GetHDImageData() else {
            onCompletion(nil)
            return
        }
        
        ImageCache.current.getChannerImage(imageData: imageData, onCompletion: {
            image in
            
            onCompletion(image)
        }, onNotFound: { [self] in
            //try for TN attachment
            
            ImageCache.current.getChannerImage(imageData: GetTNImageData()!, onCompletion: {
                image in
                
                onCompletion(image)
            }, onNotFound: {
                onCompletion(UIImage(named: "imageFail")!)
            })
        })
    }
    
    ///Completes with the uiimage of the tnattachment if it exists
    ///nil if not
    func GetTNAttachment(onCompletion: @escaping (UIImage?) -> ()) {
        guard let imageData = GetTNImageData() else {
            onCompletion(nil)
            return
        }
        
        ImageCache.current.getChannerImage(imageData: imageData, onCompletion: {
            image in
            
            onCompletion(image)
        }, onNotFound: {
            onCompletion(UIImage(named: "imageFail")!)
        })
    }
    
    //load the comment text view so
    //it doesn't have to be refreshed every time
    func GetCommentTextView() -> Text {
        guard rawData.com != nil else {
            return Text("")
        }
        
        if commentTextView == nil {
            commentTextView = GetCommentView(fromString: rawData.com!)
        }
        
        return commentTextView!
    }
    
    ///Returns the date posted
    func GetDatePosted() -> Date {
        return (NSDate(timeIntervalSince1970: TimeInterval(rawData.time ?? 0)) as Date)
    }
    
    //Returns empty "" if there is no subject
    func GetSubject() -> String {
        return (rawData.sub ?? "").removingHTMLEntities()
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
                      fileExt: rawData.ext!)
    }
    
    ///Depreciated
    
    ///Loads the attachment for this post, if it exists
    ///Loads into this object's properties
    @available (*, deprecated, message: "use GetHDAttachment instead")
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
                self.hdAttachment = Image("imageFail")
            }
        }
    }
    
    ///Loads the TN attachment for this post if it exists
    ///Loads into this object's properties
    @available (*, deprecated, message: "use GetTNAttachment instead")
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
            if error == .imageNotFound {
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
                        self.hdAttachment = Image("imageFail")
                        self.tnAttachment = Image("imageFail")
                    }
                })
            }
        }
    }
    
    private var hdAttachment : Image? {
        didSet {
            hdAttachmentLoaded = true
        }
    }
    
    private var tnAttachment : Image? {
        didSet {
            tnAttachmentLoaded = true
        }
    }
}


