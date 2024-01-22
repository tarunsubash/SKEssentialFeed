//
//  FeedLoader.swift
//  SKEssentialFeed
//
//  Created by Subash on 23/10/23.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
