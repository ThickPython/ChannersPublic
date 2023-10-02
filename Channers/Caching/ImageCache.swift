//
//  ImageCache.swift
//  Channers
//
//  Created by Rez on 5/19/23.
//

import Foundation
import SwiftUI

///Singleton controller handles caching for the entire app
final class ImageCache {
    static var current = ImageCache()
    private let cache = Cache<String, UIImage>()
    
    ///Asyncronously loads an image into cache and returns the image to be displayed
    ///If the image already exists just return it from the cache
    func loadChannerImage(imageData : ChanImageData,
                          onCompletion: @escaping (UIImage) -> (),
                          onFailure: @escaping (Error) -> ()) {
        print("Loading image for url \(imageData.urlStr)")
        guard cache.getEntry(imageData.urlStr) == nil else {
            print("Entry already exists, loading from cache")
            onCompletion(cache.getEntry(imageData.urlStr)!)
            return
        }
        
        guard let url = URL(string: imageData.urlStr) else {
            onFailure(ImageCacheErrors.invalidUrl)
            return
        }
        
        print("Entry doesn't exist, loading from web")
        DataRequest.GetImageData(fromURL: url, onSuccess: {
            image in
            print("got successful image, storing to cache")
            self.cache.insertEntry(imageData.urlStr, withValue: image)
            onCompletion(image)
        }, onImageFail: {
            error in onFailure(error)
        }, onRequestFail: {
            error in onFailure(error)
        })
    }
    
    enum ImageCacheErrors : Error {
        case invalidUrl
    }
}


