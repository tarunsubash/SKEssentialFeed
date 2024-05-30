//
//  XCTestCase+FeedStoreSpecs.swift
//  SKEssentialFeedTests
//
//  Created by Subash on 30/05/24.
//

import XCTest
import SKEssentialFeed

extension FeedStoreSpecs where Self: XCTestCase {
    @discardableResult
    func insert(_ cache: (feed: [LocalFeedImage], timeStamp: Date), to sut: FeedStore) -> Error? {
        let exp = expectation(description: "Wait for Cache Insertion")
        var recievcedError: Error?
        sut.insert(cache.feed, timeStamp: cache.timeStamp) { insertionError in
            recievcedError = insertionError
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        return recievcedError
    }
    
    @discardableResult
    func deleteCache(from sut: FeedStore) -> Error? {
        let exp = expectation(description: "wait for cache deletion")
        var recievedError: Error?
        sut.deleteCachedFeed { deletionError in
            recievedError = deletionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
        return recievedError
    }
    
    func expect(_ sut: FeedStore, toRetrieveTwice expectedResult: RetrieveCachedFeedResult, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }
    
    func expect(_ sut: FeedStore, toRetrieve expectedResult: RetrieveCachedFeedResult, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for retrieve completion")
        
        sut.retrieve { recievedResult in
            switch (expectedResult, recievedResult) {
            case (.empty, .empty), (.failure, .failure):
                break
            case let (.found(expectedFeed, expectedTimeStamp), .found(recievedFeed, recievedTimeStamp)):
                XCTAssertEqual(expectedFeed, recievedFeed, file: file, line: line)
                XCTAssertEqual(expectedTimeStamp, recievedTimeStamp, file: file, line: line)
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(recievedResult) instead.")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
}
