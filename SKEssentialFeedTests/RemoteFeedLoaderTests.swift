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
        
        expect(sut,
               toCompleteWithResult: .failure(.connectivity)) {
            let clientError = NSError(domain: "Connectivity", code: 0)
            client.complete(with: clientError)
        }
    }
    
    func test_Load_DeliversInvalidDataError_OnNon200HTTPResponses() {
        let (sut, client) = makeSUT()
        
        let samples = [199,201,300,400,500]
        samples.enumerated().forEach { index, code in
          expect(sut,
                 toCompleteWithResult: .failure(.invalidData)) {
              let clientError = NSError(domain: "Connectivity", code: 0)
              client.complete(withStatusCode: 400, data: makeItemsJSON([]), at: index)
          }
        }
    }
    
    func test_Load_DeliversInvalidDataError_On200HTTPResponsesWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut,
               toCompleteWithResult: .failure(.invalidData)) {
            let invalidJSONData = Data("Invalid Data".utf8)
            client.complete(withStatusCode: 200, data: invalidJSONData)
        }
    }
    
    func test_Load_DeliversEmptyList_On200HTTPResponsesWithEmptyJSONLis() {
        let (sut, client) = makeSUT()
        
        expect(sut,
               toCompleteWithResult: .success([])) {
            let emptyJSONList = Data("{\"items\": []}".utf8)
            client.complete(withStatusCode: 200, data: emptyJSONList)
        }
    }
    
    func test_Load_DeliversItems_On200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        
        let item1 = makeItem(uuid: UUID(),
                             imageURL: URL(string: "https://test-url.com")!)
        
        
        let item2 = makeItem(uuid: UUID(),
                             description: "description",
                             location: "location",
                             imageURL: URL(string: "htps:test-url-two.com")!)
        
        expect(sut, toCompleteWithResult: .success([item1.model,
                                                    item2.model])) {
            let json = makeItemsJSON([item1.json, item2.json])
            client.complete(withStatusCode: 200, data: json)
        }
    }
    
    // MARK: Test Helpers
    
    private func makeSUT(url: URL = URL(string: "https://test-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url,
                                   client: client)
        return (sut, client)
    }
    
    private func makeItem(uuid: UUID, description: String? = nil, location: String? = nil, imageURL: URL) -> (model: FeedItem, json: [String: Any]) {
        let item = FeedItem(uuid: uuid, description: description, location: location, imageURL: imageURL)
        
        let json = [
            "id": uuid.uuidString,
            "description": description,
            "location": location,
            "image": imageURL.absoluteString
        ].compactMapValues { $0 }
        return (item, json)
    }
    
    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        let json = ["items": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func expect(_ sut: RemoteFeedLoader,
                        toCompleteWithResult result: RemoteFeedLoader.Result,
                        when action: () -> (),
                        file: StaticString = #filePath,
                        line: UInt = #line) {
        var capturedResults = [RemoteFeedLoader.Result]()
        
        sut.load { capturedResults.append($0) }
        
        action()
        
        XCTAssertEqual(capturedResults, [result], file: file , line: line)
    }
    
    /*
     A Spy is different from a Mock or a Fake Implementation
     A spy is generally used to capture values reather than stubbing (as in the case of mock classes)
     It gives a much better control over data.
     */
    private class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()

        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        // MARK: Helper Methods for SPY
        /*
         An alternative approach to stubbing, where the control lies with the Developer and also each time a test is executed, the data is revoked.
         */
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            let httpResponse = HTTPURLResponse(url: requestedURLs[index],
                                               statusCode: code,
                                               httpVersion: nil,
                                               headerFields: nil)!
            messages[index].completion(.success(httpResponse, data))
        }
    }
}
