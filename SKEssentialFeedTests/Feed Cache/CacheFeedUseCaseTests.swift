//
//  CacheFeedUseCaseTests.swift
//  SKEssentialFeedTests
//
//  Created by Subash on 16/05/24.
//

import XCTest
import SKEssentialFeed

class LocalFeedLoader {
    let store: FeedStore
    
    init(store: FeedStore) {
        self.store = store
    }
    
    func save(_ items: [FeedItem]) {
        store.deleteCachedFeed()
    }
}

class FeedStore {
    var deletedCacheFeedCount = 0
    
    func deleteCachedFeed() {
        deletedCacheFeedCount += 1
    }
}

final class CacheFeedUseCaseTests: XCTestCase {
    func test_init_doesnotDeleteCacheUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.deletedCacheFeedCount, 0)
    }
    
    func test_save_requestCacheDeletion() {
        let (sut, store) = makeSUT()
        let items = [uniqueItem()]
        sut.save(items)
        XCTAssertEqual(store.deletedCacheFeedCount, 1)
    }
    
    // Helpers:
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStore) {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store)
        
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, store)
    }
    
    private func uniqueItem() -> FeedItem {
        FeedItem(uuid: UUID(), description: "desc", location: "loc", imageURL: anyURL())
    }
    
    private func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
}

