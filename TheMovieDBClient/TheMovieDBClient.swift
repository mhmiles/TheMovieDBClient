//
//  TheMovieDBClient.swift
//  TheMovieDBClient
//
//  Created by Miles Hollingsworth on 9/9/16.
//  Copyright © 2016 Miles Hollingsworth. All rights reserved.
//

import Foundation
import Alamofire
import enum Result.Result

let TheMovieDBAPIBaseURL = NSURL(string: "https://api.themoviedb.org")!
let TheMovieDBImageBaseURL = NSURL(string: "https://image.tmdb.org/t/p/w600")!

public enum TheMovieDBMediaType {
    case Film
    case TelevisionShow
    case TelevisionEpisode
    case Unknown
    case NotApplicable
}

public enum TheMovieDBError: ErrorType {
    case UnhandledMediaType
    case RequestError(NSError)
    case NoResults
    case NoImages
}

public typealias TheMovieDBQueryResult = Result<NSURL, TheMovieDBError>

public class TheMovieDBClient {
    public static var apiKey: String?
    
    private var _apiKey: String {
        guard let apiKey = TheMovieDBClient.apiKey else {
            print("TheMovieDBClient.apiKey must be set before making requests")
            abort()
        }
        
        return apiKey
    }
    
    static let shared = TheMovieDBClient()
    
    public func getImageURL(title: String, mediaType: TheMovieDBMediaType, completion: (TheMovieDBQueryResult -> Void)) {
        let requestPath: String
        
        switch mediaType {
        case .Film:
            requestPath = "3/search/movie"
            
        case .TelevisionShow:
            requestPath = "3/search/tv"
            
        default:
            completion(.Failure(.UnhandledMediaType))
            return
        }
        
        let parameters = [
            "api_key": _apiKey,
            "query": title
        ]
        
        Alamofire.request(.GET, TheMovieDBAPIBaseURL.URLByAppendingPathComponent(requestPath), parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .Success(let json as NSDictionary):
                let titleKey: String
                
                switch mediaType {
                case .Film:
                    titleKey = "title"
                    
                case .TelevisionShow:
                    titleKey = "name"
                    
                default:
                    return
                }
                
                guard let results = json["results"] as? [NSDictionary] where results.count > 0 else {
                    completion(.Failure(.NoResults))
                    return
                }
                
                guard let imagePath = results.filter({ $0[titleKey] as? String == title }).first?["backdrop_path"] as? String else {
                    completion(.Failure(.NoImages))
                    return
                }
                
                let imageURL = TheMovieDBImageBaseURL.URLByAppendingPathComponent(imagePath)
                completion(.Success(imageURL))
               
            case .Failure(let error):
                completion(.Failure(.RequestError(error)))
                
            default:
                print("UNHANDLED")
            }
        }
    }
}