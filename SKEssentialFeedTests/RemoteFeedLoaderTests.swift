//
//  RemoteFeedLoaderTests.swift
//  SKEssentialFeedTests
//
//  Created by Subash on 27/10/23.
//

import XCTest
class RemoteFeedLoader {
    let client: HTTPClient
    let url: URL
    
    init(url:URL,
         client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    func load() {
        client.get(from: url)
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

        _ = RemoteFeedLoader(url: URL(string: "https://test-url.com")!,
                             client: client)
                
        XCTAssertNil(client.requestedURL)
    }

    
    func test_Load_RequestDataFromURL() {
        let client = FakeHTTPClient()
        let expectedURL = URL(string: "https://test-url.com")!
        let sut = RemoteFeedLoader(url: expectedURL,
                                   client: client)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURL, expectedURL)
    }
}
