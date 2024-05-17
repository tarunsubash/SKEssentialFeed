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
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    public func save(_ items: [FeedItem], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedFeed { [weak self] error in
            guard let self = self else { return }
            if error != nil {
                completion(error)
            } else {
                self.cache(items: items, with: completion)
            }
        }
    }
    
    private func cache(items: [FeedItem], with completion: @escaping (SaveResult) -> Void) {
        store.insert(items, timeStamp: self.currentDate()) {  [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
}
