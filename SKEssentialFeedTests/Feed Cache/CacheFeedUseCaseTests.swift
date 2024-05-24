//
//  CacheFeedUseCaseTests.swift
//  SKEssentialFeedTests
//
//  Created by Subash on 16/05/24.
//

import XCTest
import SKEssentialFeed

final class CacheFeedUseCaseTests: XCTestCase {
    func test_init_doesnotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.recievedMessages, [])
    }
    
    func test_save_requestCacheDeletion() {
        let (sut, store) = makeSUT()
        
        sut.save(uniqueImageFeed().models) { _ in }
        
        XCTAssertEqual(store.recievedMessages, [.deleteCacheFeed])
    }
    
    func test_save_doesnotRequestCacheInsertionOnDeletionError() {
        let (sut, store) = makeSUT()
        let deletionError = anyError()
        
        sut.save(uniqueImageFeed().models) { _ in }
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.recievedMessages, [.deleteCacheFeed])
        
    }
    
    func test_save_requestNewCacheInsertionWithTimeStampOnSuccessfulDeletion() {
        let timeStamp = Date()
        let (sut, store) = makeSUT(currentDate: { timeStamp })
        let feed = uniqueImageFeed()
        
        sut.save(feed.models) { _ in }
        store.completeDeletionSuccessfully()
        
        XCTAssertEqual(store.recievedMessages, [.deleteCacheFeed, .insert(feed.local, timeStamp)])
    }
    
    func test_save_failsOnDeletionError() {
        let (sut, store) = makeSUT()
        let deletionError = anyError()
        
        expect(sut, toCompleteWithError: deletionError) {
            store.completeDeletion(with: deletionError)
        }
    }
    
    func test_save_failsOnInsertionError() {
        let (sut, store) = makeSUT()
        let insertionError = anyError()
        
        expect(sut, toCompleteWithError: insertionError) {
            store.completeDeletionSuccessfully()
            store.completeInsertion(with: insertionError)
        }
    }
    
    func test_save_succeedsOnCacheInsertion() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWithError: nil) {
            store.completeDeletionSuccessfully()
            store.completeInsertionSuccessfully()
        }
    }
    
    func test_save_doesNotDelivereDeletionErrorAfterSUTisDeallocated() {
        let store = FeedStoreSpy()
        
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)
        
        var recievedResults = [LocalFeedLoader.SaveResult]()
        
        sut?.save([uniqueItem()], completion: { recievedResults.append($0) })
        sut = nil
        store.completeDeletion(with: anyError())
        
        XCTAssertTrue(recievedResults.isEmpty)
    }
    
    func test_save_doesNotDelivereInsertionErrorAfterSUTisDeallocated() {
        let store = FeedStoreSpy()
        
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)
        
        var recievedResults = [LocalFeedLoader.SaveResult]()
        
        sut?.save([uniqueItem()], completion: { recievedResults.append($0) })
        store.completeDeletionSuccessfully()
        sut = nil
        store.completeInsertion(with: anyError())
        
        XCTAssertTrue(recievedResults.isEmpty)
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
    
    func expect(_ sut: LocalFeedLoader,
                toCompleteWithError expectedError: NSError?,
                when action: () -> Void,
                file: StaticString = #filePath,
                line: UInt = #line) {
        let exp = expectation(description: "Wait for save completion")
        var recievedError: Error?
        
        sut.save([uniqueItem()]) { error in
            recievedError = error
            exp.fulfill()
        }
        action()
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(recievedError as? NSError, expectedError, file: file, line: line)
    }
}

