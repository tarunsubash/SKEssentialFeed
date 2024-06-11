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
        deletionCompletions[index](error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }
    
    func insert(_ items: [LocalFeedImage], timeStamp: Date, completion: @escaping InsertionCompletion) {
        insertionCompletions.append(completion)
        recievedMessages.append(.insert(items, timeStamp))
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](nil)
    }
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        retrievalCompletions.append(completion)
        recievedMessages.append(.retrieve)
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }
    
    func completeRetrievalWithEmptyCache(at index: Int = 0) {
        retrievalCompletions[index](.success(.empty))
    }
    
    func completeRetrieval(with feed: [LocalFeedImage], timeStamp: Date, at index: Int = 0) {
        retrievalCompletions[index](.success(.found(feed: feed,
                                           timeStamp: timeStamp)))
    }
}
