//
//  ValidateFeedCacheUseCaseTests.swift
//  SKEssentialFeedTests
//
//  Created by Subash on 24/05/24.
//

import XCTest
import SKEssentialFeed

final class ValidateFeedCacheUseCaseTests: XCTestCase {
    func test_init_doesnotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.recievedMessages, [])
    }
    
    func test_validateCache_deletesCacheOnRetrievalError() {
        let (sut, store) = makeSUT()
        
        sut.validateCache()
        
        store.completeRetrieval(with: anyError())
        
        XCTAssertEqual(store.recievedMessages, [.retrieve, .deleteCacheFeed])
    }
    
    func test_validateCache_doesnotDeleteCacheOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        sut.validateCache()
        
        store.completeRetrievalWithEmptyCache()
        
        XCTAssertEqual(store.recievedMessages, [.retrieve])
    }
    
    func test_validate_doesNotDeleteNonExpiredCache() {
        let feed = uniqueImageFeed()
        let fixedCurrentDate = Date()
        
        let nonExpiredTimeStamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: 1)

        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        sut.load { _ in }
        
        store.completeRetrieval(with: feed.local, timeStamp: nonExpiredTimeStamp)
        
        XCTAssertEqual(store.recievedMessages, [.retrieve])
    }
    
    func test_validate_DeletesCacheOnExpiration() {
        let feed = uniqueImageFeed()
        let fixedCurrentDate = Date()
        
        let expirationTimeStamp = fixedCurrentDate.minusFeedCacheMaxAge()

        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        sut.validateCache()
        
        store.completeRetrieval(with: feed.local, timeStamp: expirationTimeStamp)
        
        XCTAssertEqual(store.recievedMessages, [.retrieve, .deleteCacheFeed])
    }
    
    func test_validate_DeletesExpiredCache() {
        let feed = uniqueImageFeed()
        let fixedCurrentDate = Date()
        
        let expiredTimeStamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: -1)

        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        sut.validateCache()
        
        store.completeRetrieval(with: feed.local, timeStamp: expiredTimeStamp)
        
        XCTAssertEqual(store.recievedMessages, [.retrieve, .deleteCacheFeed])
    }
    
    func test_validate_DoesNotDeleteCacheAfterSUTHasBeenDealloacted() {
        let store = FeedStoreSpy()
        
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)
        
        sut?.validateCache()
        sut = nil
        store.completeRetrieval(with: anyError())
        
        XCTAssertEqual(store.recievedMessages, [.retrieve])
        
    }
    
    // MARK: - Helpers:
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init,
                         file: StaticString = #filePath,
                         line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, store)
    }
}
