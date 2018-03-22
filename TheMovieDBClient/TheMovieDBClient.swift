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

let TheMovieDBAPIBaseURL = URL(string: "https://api.themoviedb.org")!
let TheMovieDBImageBaseURL = URL(string: "https://image.tmdb.org/t/p/w500")!

public enum TheMovieDBMediaType {
    case film
    case televisionShow
    case televisionEpisode
    case unknown
    case notApplicable
}

public enum TheMovieDBError: Error {
    case unhandledMediaType
    case requestError(NSError)
    case noResults
    case noImages
}

public typealias TheMovieDBQueryResult = Result<URL, TheMovieDBError>

open class TheMovieDBClient {
    open static var apiKey: String?
    
    fileprivate var _apiKey: String {
        guard let apiKey = TheMovieDBClient.apiKey else {
            print("TheMovieDBClient.apiKey must be set before making requests")
            abort()
        }
        
        return apiKey
    }
    
    public static let shared = TheMovieDBClient()
    
    open func getImageURL(_ title: String, mediaType: TheMovieDBMediaType, completion: @escaping ((TheMovieDBQueryResult) -> Void)) {
        let requestPath: String
        
        switch mediaType {
        case .film:
            requestPath = "3/search/movie"
            
        case .televisionShow:
            requestPath = "3/search/tv"
            
        default:
            completion(.failure(.unhandledMediaType))
            return
        }
        
        let parameters = [
            "api_key": _apiKey,
            "query": title
        ]
        
        Alamofire.request(TheMovieDBAPIBaseURL.appendingPathComponent(requestPath), parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .success(let json as NSDictionary):
                let titleKey: String
                
                switch mediaType {
                case .film:
                    titleKey = "title"
                    
                case .televisionShow:
                    titleKey = "name"
                    
                default:
                    return
                }
                
                guard let results = json["results"] as? [NSDictionary] , results.count > 0 else {
                    completion(.failure(.noResults))
                    return
                }
                
                guard let imagePath = results.filter({ $0[titleKey] as? String == title }).first?["backdrop_path"] as? String else {
                    completion(.failure(.noImages))
                    return
                }
                
                let imageURL = TheMovieDBImageBaseURL.appendingPathComponent(imagePath)
                completion(.success(imageURL))
               
            case .failure(let error as NSError):
                completion(.failure(.requestError(error)))
                
            default:
                print("UNHANDLED")
            }
        }
    }
}
