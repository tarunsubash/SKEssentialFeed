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



final class RemoteFeedLoaderTests: XCTestCase {
    
    func testRemoteFeedLoader_WhenInitialized_DoesnotMakeAReuqest() {
        let (_, client) = makeSUT()
                
        XCTAssertNil(client.requestedURL)
    }

    
    func test_Load_RequestDataFromURL() {
        let expectedURL = URL(string: "https://test-url.com")!
        
        let (sut, client) = makeSUT(url: expectedURL)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURL, expectedURL)
    }
    
    private func makeSUT(url: URL = URL(string: "https://test-url.com")!) -> (sut: RemoteFeedLoader, client: FakeHTTPClient) {
        let client = FakeHTTPClient()
        let sut = RemoteFeedLoader(url: url,
                                   client: client)
        return (sut, client)
    }
    
    private class FakeHTTPClient: HTTPClient {
        var requestedURL: URL?
        
        func get(from url: URL) {
            requestedURL = url
        }
    }
}
