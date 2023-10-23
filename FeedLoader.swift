//
//  FeedLoader.swift
//  SKEssentialFeed
//
//  Created by Subash on 23/10/23.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
