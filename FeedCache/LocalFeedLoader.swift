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
    
    private let calendar = Calendar(identifier: .gregorian)
    private var maxCacheAgeInDays: Int { 7 }
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    private func validate(_ timeStamp: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timeStamp) else { return false }
        return currentDate() < maxCacheAge
    }
}

extension LocalFeedLoader {
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
}

extension LocalFeedLoader: FeedLoader {
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .failure(error):
                completion(.failure(error))
                
            case let .found(feed, timeStamp) where self.validate(timeStamp):
                completion(.success(feed.toModels()))
                
            case .found, .empty:
                completion(.success([]))
            }
        }
    }
}

extension LocalFeedLoader {
    public func validateCache() {
        store.retrieve { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure:
                self.store.deleteCachedFeed { _ in }
            case let .found(_, timeStamp) where !self.validate(timeStamp):
                self.store.deleteCachedFeed { _ in }
            default: break
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


public extension Array where Element == LocalFeedImage {
    func toModels() -> [FeedImage] {
        map { FeedImage(uuid: $0.uuid,
                            description: $0.description,
                            location: $0.location,
                            url: $0.url) }
    }
}
