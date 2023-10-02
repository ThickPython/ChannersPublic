//
//  RequestsMethod.swift
//  Channers
//
//  Created by Rez on 4/12/23.
//

import Foundation
import WebKit

///Handles HTTPRequests
///Super low level, higher level things pull from here to get their data
class DataRequest {
    ///Grabs data for an image
    ///Completes with the image on success
    ///Throws failure on fail
    static func GetImageData(fromURL : URL, onSuccess: @escaping (UIImage) -> (),
                             onImageFail: @escaping (ImageError) -> (),
                             onRequestFail: @escaping (RequestError) ->()) {
        var request = URLRequest(url: fromURL)
        request.httpMethod = "GET"
        DataRequest.Request(request, DataHandler: {
            data in
            
            guard let image = UIImage(data: data) else {
                onImageFail(.cannotConvertData)
                return
            }
            
            onSuccess(image)
        }, onFailure: { error in
            onRequestFail(error)
        })
    }
    
    ///Gets an object from a json request as an object array
    ///Fails if there is a request error
    static func GetObjectDataArray<T:Codable>(fromURL: URL, ofType: T.Type,
                                              onSuccess: @escaping ([T]) -> (),
                                              onFailure: @escaping (RequestError) -> ()) {
        var request = URLRequest(url: fromURL)
        request.httpMethod = "GET"
        DataRequest.Request(request) { data in
            let decoder = JSONDecoder()
            do {
                let decoded = try decoder.decode([T].self, from: data)
                onSuccess(decoded)
            } catch {
                print("Error \(error)")
            }
        } onFailure: { error in
            onFailure(error)
        }
    }
    
    ///Gets an object from a json request
    static func GetObjectData<T:Codable>(fromURL: URL, ofType: T.Type,
                                         onSuccess: @escaping (T) -> (),
                                         onFailure: @escaping (RequestError) -> ()) {
        var request = URLRequest(url: fromURL)
        request.httpMethod = "GET"
        DataRequest.Request(request) { data in
            let decoder = JSONDecoder()

            do {
                let decoded = try decoder.decode(T.self, from: data)
                onSuccess(decoded)
            } catch {
                print("Error \(error)")
            }
        } onFailure: { error in
            onFailure(error)
        }
    }
    
    ///The most basic method it just requests data from the web
    static func Request(_ request : URLRequest,
                        DataHandler: @escaping (Data) -> (),
                        onFailure: @escaping(RequestError) -> ()) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                onFailure(RequestError.unknownError)
            }
            
            guard (response as? HTTPURLResponse)?.statusCode != 404 else {
                onFailure(RequestError.notFound)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                onFailure(RequestError.nonSuccessResponseCode)
                return
            }
            
            DataHandler(data!)
        }
        task.resume()
    }
}

///Error to represent a network request error
enum RequestError : Error {
    case unknownError
    case nonSuccessResponseCode
    case notFound
}

///Error to represent a failure in getting image data
enum ImageError : Error {
    case cannotConvertData
}
