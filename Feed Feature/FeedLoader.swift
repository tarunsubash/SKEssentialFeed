//
//  FeedLoader.swift
//  SKEssentialFeed
//
//  Created by Subash on 23/10/23.
//

import Foundation

public protocol FeedLoader {
    typealias Result = Swift.Result<[FeedImage], Error>
    func load(completion: @escaping (Result) -> Void)
}
