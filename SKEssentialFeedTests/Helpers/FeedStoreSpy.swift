//
//  FeedStoreSpy.swift
//  SKEssentialFeedTests
//
//  Created by Subash on 23/05/24.
//

import Foundation
import SKEssentialFeed

class FeedStoreSpy: FeedStore {
    
    enum RecievedMessage: Equatable {
        case deleteCacheFeed
        case insert([LocalFeedImage], Date)
        case retrieve
    }
    
    private (set) var recievedMessages = [RecievedMessage]()
    
    private var deletionCompletions = [DeletionCompletion]()
    private var insertionCompletions = [InsertionCompletion]()
    private var retrievalCompletions = [RetrievalCompletion]()
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        deletionCompletions.append(completion)
        recievedMessages.append(.deleteCacheFeed)
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](.failure(error))
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](.success(()))
    }
    
    func insert(_ items: [LocalFeedImage], timeStamp: Date, completion: @escaping InsertionCompletion) {
        insertionCompletions.append(completion)
        recievedMessages.append(.insert(items, timeStamp))
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](.failure(error))
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](.success(()))
    }
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        retrievalCompletions.append(completion)
        recievedMessages.append(.retrieve)
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }
    
    func completeRetrievalWithEmptyCache(at index: Int = 0) {
        retrievalCompletions[index](.success(.none))
    }
    
    func completeRetrieval(with feed: [LocalFeedImage], timeStamp: Date, at index: Int = 0) {
        retrievalCompletions[index](.success(.some(CachedFeed(feed: feed,
                                           timeStamp: timeStamp))))
    }
}
