//
//  FeedCacheTestHelpers.swift
//  SKEssentialFeedTests
//
//  Created by Subash on 24/05/24.
//

import Foundation
import SKEssentialFeed

func uniqueItem() -> FeedImage {
    FeedImage(uuid: UUID(), description: "desc", location: "loc", url: anyURL())
}

func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
    let models = [uniqueItem(), uniqueItem()]
    let local = models.map { LocalFeedImage(uuid: $0.uuid, description: $0.description, location: $0.location, url: $0.url)}
    return (models, local)
}


extension Date {
    private var feedCacheMaxAgeInDays: Int { 7 }
    
    func minusFeedCacheMaxAge() -> Date {
        adding(days: -feedCacheMaxAgeInDays)
    }
    
    func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
    
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
