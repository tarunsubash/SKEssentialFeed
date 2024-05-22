//
//  LocalFeedItem.swift
//  SKEssentialFeed
//
//  Created by Subash on 22/05/24.
//

import Foundation

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
