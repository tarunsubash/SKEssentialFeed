//
//  XCTestCase+FailableInsertFeedStoreSpecs.swift
//  SKEssentialFeedTests
//
//  Created by Subash on 30/05/24.
//

import XCTest
import SKEssentialFeed

extension FailableInsertFeedStoreSpecs where Self: XCTestCase {
    /*
     func test_insert_deliversErrorOnInsertionError()
     func test_insert_hasNoSideEffectsOnInsertionError()
     */
    
    func assertThatInsertDeliversNoErrorOnInsertionError(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        let insertionError = insert((uniqueImageFeed().local, Date()), to: sut)
        
        XCTAssertNotNil(insertionError, "Expected cache insertion to fail with with an error", file: file, line: line)
    }
    
    func assertThatInsertHasNoSideEffectOnInsertionError(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        insert((uniqueImageFeed().local, Date()), to: sut)
        
        expect(sut, toRetrieve: .success(.empty), file: file, line: line)
    }
}
