//
//  RemoteFeedLoaderTests.swift
//  SKEssentialFeedTests
//
//  Created by Subash on 27/10/23.
//

import XCTest
class RemoteFeedLoader {
    let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func load() {
        client.get(from: URL(string: "https://test-url.com")!)
    }
}

protocol HTTPClient {
    func get(from url: URL)
}

class FakeHTTPClient: HTTPClient {
    var requestedURL: URL?
    
    func get(from url: URL) {
        requestedURL = url
    }
}

final class RemoteFeedLoaderTests: XCTestCase {
    
    func testRemoteFeedLoader_WhenInitialized_DoesnotMakeAReuqest() {
        let client = FakeHTTPClient()

        _ = RemoteFeedLoader(client: client)
                
        XCTAssertNil(client.requestedURL)
    }

    
    func test_Load_RequestDataFromURL() {
        let client = FakeHTTPClient()
        let sut = RemoteFeedLoader(client: client)
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
}
