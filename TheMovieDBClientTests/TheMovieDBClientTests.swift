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
        TheMovieDBClient.apiKey = nil
        
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
        let expectation = expectationWithDescription("Television Show Query Timeout")
        
        client.getImageURL("The Simpsons", mediaType: .TelevisionShow) { (result) in
            switch result {
            case .Success(let imageURL):
                guard let data = NSData(contentsOfURL: imageURL), _ = UIImage(data: data) else {
                    XCTFail("Image load failure")
                    return
                }
                
                expectation.fulfill()
                
            case .Failure(let error):
                print(error)
                XCTFail()
            }
        }
        
        waitForExpectationsWithTimeout(10.0) { (error) in
            print(error)
        }
    }
    
    func testMovie() {
        let expectation = expectationWithDescription("Television Show Query Timeout")
        
        client.getImageURL("The Matrix", mediaType: .Film) { (result) in
            switch result {
            case .Success(let imageURL):
                guard let data = NSData(contentsOfURL: imageURL), _ = UIImage(data: data) else {
                    XCTFail("Image load failure")
                    return
                }
                
                expectation.fulfill()
                
            case .Failure(let error):
                print(error)
                XCTFail()
            }
        }
        
        waitForExpectationsWithTimeout(10.0) { (error) in
            print(error)
        }
    }
    
}
