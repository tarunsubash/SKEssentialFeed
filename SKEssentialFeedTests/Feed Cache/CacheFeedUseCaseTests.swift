//
//  CacheFeedUseCaseTests.swift
//  SKEssentialFeedTests
//
//  Created by Subash on 16/05/24.
//

import XCTest

class LocalFeedLoader {
    let store: FeedStore
    
    init(store: FeedStore) {
        self.store = store
    }
}

class FeedStore {
    var deletedCacheFeedCount = 0
}

final class CacheFeedUseCaseTests: XCTestCase {
    func test_init_doesnotDeleteCacheUponCreation() {
        let store = FeedStore()
        _ = LocalFeedLoader(store: store)
        
        XCTAssertEqual(store.deletedCacheFeedCount, 0)
    }
}

