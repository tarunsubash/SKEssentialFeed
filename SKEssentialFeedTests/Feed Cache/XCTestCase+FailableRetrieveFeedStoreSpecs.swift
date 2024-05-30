//
//  XCTestCase+FailableRetrieveFeedStoreSpecs.swift
//  SKEssentialFeedTests
//
//  Created by Subash on 30/05/24.
//

import XCTest
import SKEssentialFeed

extension FailableRetrieveFeedStoreSpecs where Self: XCTestCase {

    func assertThatRetrieveDeliversFailureOnRetrievalError(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: .failure(anyError()), file: file, line: line)
    }
    
    func assertThatRetrieveHasNoSideEffectsOnFailure(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieveTwice: .failure(anyError()), file: file, line: line)
    }
}
