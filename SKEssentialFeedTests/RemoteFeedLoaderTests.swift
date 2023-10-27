//
//  RemoteFeedLoaderTests.swift
//  SKEssentialFeedTests
//
//  Created by Subash on 27/10/23.
//

import XCTest
class RemoteFeedLoader {
    func load() {
        HTTPClient.shared.requestedURL = URL(string: "https://test-url.com")
    }
}

class HTTPClient {
    static let shared = HTTPClient()
    
    private init() {}
    
    var requestedURL: URL?
}

final class RemoteFeedLoaderTests: XCTestCase {
    
    func testRemoteFeedLoader_WhenInitialized_DoesnotMakeAReuqest() {
        _ = RemoteFeedLoader()
        
        let client = HTTPClient.shared
        
        XCTAssertNil(client.requestedURL)
    }

    
    func test_Load_RequestDataFromURL() {
        let sut = RemoteFeedLoader()
        let client = HTTPClient.shared
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
}
