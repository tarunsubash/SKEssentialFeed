//
//  CodableFeedStoreTests.swift
//  SKEssentialFeedTests
//
//  Created by Subash on 28/05/24.
//

import XCTest
import SKEssentialFeed

class CodableFeedStore {
    
    private struct Cache: Codable {
        let feed: [CodableFeedImage]
        let timeStamp: Date
        
        var localFeed: [LocalFeedImage] {
            feed.map { $0.local }
        }
    }
    
    private struct CodableFeedImage: Equatable, Codable {
        public let uuid: UUID
        public let description: String?
        public let location: String?
        public let url: URL
        
        public init(uuid: UUID, description: String? = nil, location: String? = nil, url: URL) {
            self.uuid = uuid
            self.description = description
            self.location = location
            self.url = url
        }
        
        var local: LocalFeedImage {
            LocalFeedImage(uuid: uuid,
                           description: description,
                           location: location,
                           url: url)
        }
    }
    
    private let storeURL = FileManager.default.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first!.appendingPathComponent("image-feed.store")
    
    func retrieve(completion: @escaping FeedStore.RetrievalCompletion) {
        guard let data = try? Data(contentsOf: storeURL) else { return completion(.empty) }
        let decoder = JSONDecoder()
        let cache = try! decoder.decode(Cache.self, from: data)
        completion(.found(feed: cache.localFeed, timeStamp: cache.timeStamp))
    }
    
    func insert(_ feed: [LocalFeedImage], timeStamp: Date, completion: @escaping FeedStore.InsertionCompletion) {
        let encoder = JSONEncoder()
        let cache = Cache(feed: feed.map{ CodableFeedImage(uuid: $0.uuid, description: $0.description, location: $0.location, url: $0.url)}, timeStamp: timeStamp)
        let encoded = try! encoder.encode(cache)
        try! encoded.write(to: storeURL)
        completion(nil)
    }
}

final class CodableFeedStoreTests: XCTestCase {
    let storeURL = FileManager.default.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first!.appendingPathComponent("image-feed.store")
    override func setUp() {
        super.setUp()
        try? FileManager.default.removeItem(at: storeURL)
    }
    
    override func tearDown() {
        super.tearDown()
        try? FileManager.default.removeItem(at: storeURL)
    }
    
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        let exp = expectation(description: "Wait for retrieve completion")
        
        sut.retrieve { result in
            switch result {
            case .empty: break
            default: XCTFail("Expected empty result, got \(result) instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        let exp = expectation(description: "Wait for retrieve completion")
        
        sut.retrieve { firstResult in
            sut.retrieve { secondResult in
                switch (firstResult, secondResult) {
                case (.empty, .empty): break
                default: XCTFail("Expected retriev to deliver same result twice, got \(firstResult) and \(secondResult) instead")
                }
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_retrieveAfterInsertingIntoEmptyCache_deliversInsertedValues() {
        let sut = makeSUT()
        let feed = uniqueImageFeed().local
        let timeStamp = Date()
        let exp = expectation(description: "Wait for retrieve completion")
        
        sut.insert(feed, timeStamp: timeStamp) { insertionError in
            XCTAssertNil(insertionError, "Expected Feed to be inserted successfully")
            sut.retrieve { retrieveResult in
                switch retrieveResult {
                case let .found(retrievedFeed, retrievedTimeStamp):
                    XCTAssertEqual(retrievedFeed, feed)
                    XCTAssertEqual(retrievedTimeStamp, timeStamp)
                default:
                    XCTFail("Expected Result to be found with \(feed) and \(timeStamp), got \(retrieveResult) instead")
                }
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    // - MARK: Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> CodableFeedStore {
        let sut = CodableFeedStore()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
