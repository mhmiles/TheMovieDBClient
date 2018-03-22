//
//  TheMovieDBClientTests.swift
//  TheMovieDBClientTests
//
//  Created by Miles Hollingsworth on 9/9/16.
//  Copyright © 2016 Miles Hollingsworth. All rights reserved.
//

import XCTest
@testable import TheMovieDBClient

class TheMovieDBClientTests: XCTestCase {
    lazy var client: TheMovieDBClient = {
        //WARNING: Set to valid API key to run tests
        TheMovieDBClient.apiKey = "786277da4a3d54e500edcd7dca1f5f18"
        
        return TheMovieDBClient.shared
    }()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTelevisionShow() {
        let timeout = expectation(description: "Television Show Query Timeout")
        
        client.getImageURL("The Simpsons", mediaType: .televisionShow) { (result) in
            switch result {
            case .success(let imageURL):
                guard let _ = UIImage(data: try! Data(contentsOf: imageURL)) else {
                    XCTFail("Image load failure")
                    return
                }
                
                timeout.fulfill()
                
            case .failure(let error):
                print(error)
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 10.0) { (error) in
            print(error)
        }
    }
    
    func testMovie() {
        let timeout = expectation(description: "Television Show Query Timeout")
        
        client.getImageURL("The Matrix", mediaType: .film) { (result) in
            switch result {
            case .success(let imageURL):
                guard let _ = UIImage(data: try! Data(contentsOf: imageURL)) else {
                    XCTFail("Image load failure")
                    return
                }
                
                timeout.fulfill()
                
            case .failure(let error):
                print(error)
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 10.0) { (error) in
            print(error)
        }
    }
    
}
