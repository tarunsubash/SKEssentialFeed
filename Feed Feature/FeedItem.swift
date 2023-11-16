//
//  FeedItem.swift
//  SKEssentialFeed
//
//  Created by Subash on 23/10/23.
//

import Foundation

public struct FeedItem: Equatable {
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

extension FeedItem: Decodable {
    private enum CodingKeys: String, CodingKey {
        case uuid
        case description
        case location
        case imageURL = "image"
    }
}
