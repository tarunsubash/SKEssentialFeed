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
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [expectedURL])
    }
    
    func test_LoadTwice_RequestDataFromURLTwice() {
        let expectedURL = URL(string: "https://test-url.com")!
        
        let (sut, client) = makeSUT(url: expectedURL)
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [expectedURL, expectedURL])
    }

    func test_Load_DeliversConnectivityError_OnClientError() {
        let (sut, client) = makeSUT()
        
        
        var capturedErrors = [RemoteFeedLoader.Error]()
        
        sut.load { capturedErrors.append($0) }
        
        let clientError = NSError(domain: "Connectivity", code: 0)
        
        client.complete(with: clientError)
        
        XCTAssertEqual(capturedErrors, [.connectivity])
        
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
        private var messages = [(url: URL, completion: (Error) -> Void)]()

        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping (Error) -> Void) {
            messages.append((url, completion))
        }
        
        // MARK: Helper Methods for SPY
        /*
         An alternative approach to stubbing, where the control lies with the Developer and also each time a test is executed, the data is revoked.
         */
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(error)
        }
    }
}
