//
//  LocalFeedItem.swift
//  SKEssentialFeed
//
//  Created by Subash on 22/05/24.
//

import Foundation

public struct LocalFeedImage: Equatable {
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
