//
//  FeedStore.swift
//  SKEssentialFeed
//
//  Created by Subash on 17/05/24.
//

import Foundation

public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    func insert(_ items: [LocalFeedItem], timeStamp: Date, completion: @escaping InsertionCompletion)
}

public struct LocalFeedItem: Equatable {
    public let uuid: UUID
    public let description: String?
    public let location: String?
    public let imageURL: URL
    
    public init(uuid: UUID, description: String? = nil, location: String? = nil, imageURL: URL) {
        self.uuid = uuid
        self.description = description
        self.location = location
        self.imageURL = imageURL
    }
}
