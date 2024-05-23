//
//  LocalFeedLoader.swift
//  SKEssentialFeed
//
//  Created by Subash on 17/05/24.
//

import Foundation

public final class LocalFeedLoader {
    let store: FeedStore
    let currentDate: () -> Date
    
    public typealias SaveResult =  Error?
    public typealias LoadResult =  LoadFeedResult
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    public func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedFeed { [weak self] error in
            guard let self = self else { return }
            if error != nil {
                completion(error)
            } else {
                self.cache(items: feed, with: completion)
            }
        }
    }
    
    private func cache(items: [FeedImage], with completion: @escaping (SaveResult) -> Void) {
        store.insert(items.toLocal(), timeStamp: self.currentDate()) {  [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { error in
            if let error = error {
                completion(.failure(error))
            }
        }
    }
}

public extension Array where Element == FeedImage {
    func toLocal() -> [LocalFeedImage] {
        map { LocalFeedImage(uuid: $0.uuid,
                            description: $0.description,
                            location: $0.location,
                            url: $0.url) }
    }
}
