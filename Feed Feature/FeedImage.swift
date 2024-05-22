//
//  FeedItem.swift
//  SKEssentialFeed
//
//  Created by Subash on 23/10/23.
//

import Foundation

public struct FeedImage: Equatable {
    public let uuid: UUID
    public let description: String?
    public let location: String?
    public let url: URL
    
    public init(uuid: UUID, description: String? = nil, location: String? = nil, url: URL) {
        self.uuid = uuid
        self.description = description
        self.location = location
        self.url = url
    }
}
