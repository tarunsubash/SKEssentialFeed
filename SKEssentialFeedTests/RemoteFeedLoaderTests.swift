//
//  RemoteFeedLoaderTests.swift
//  SKEssentialFeedTests
//
//  Created by Subash on 27/10/23.
//

import XCTest
import SKEssentialFeed

final class RemoteFeedLoaderTests: XCTestCase {
    
    func testRemoteFeedLoader_WhenInitialized_DoesnotMakeAReuqest() {
        let (_, client) = makeSUT()
                
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    
    func test_Load_RequestDataFromURL() {
        let expectedURL = URL(string: "https://test-url.com")!
        
        let (sut, client) = makeSUT(url: expectedURL)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [expectedURL])
    }
    
    func test_LoadTwice_RequestDataFromURLTwice() {
        let expectedURL = URL(string: "https://test-url.com")!
        
        let (sut, client) = makeSUT(url: expectedURL)
        
        sut.load()
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [expectedURL, expectedURL])
    }
    
    // MARK: Test Helpers
    
    private func makeSUT(url: URL = URL(string: "https://test-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url,
                                   client: client)
        return (sut, client)
    }
    
    /*
     A Spy is different from a Mock or a Fake Implementation
     A spy is generally used to capture values reather than stubbing (as in the case of mock classes)
     It gives a much better control over data.
     */
    private class HTTPClientSpy: HTTPClient {
        var requestedURLs: [URL] = []
        
        func get(from url: URL) {
            requestedURLs.append(url)
        }
    }
}
