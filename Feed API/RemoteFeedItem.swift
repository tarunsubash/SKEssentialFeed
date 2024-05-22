//
//  RemoteFeedItem.swift
//  SKEssentialFeed
//
//  Created by Subash on 22/05/24.
//

import Foundation

struct RemoteFeedItem: Decodable {
    public let id: UUID
    public let description: String?
    public let location: String?
    public let image: URL
    
    var item: FeedImage {
        return FeedImage(uuid: id, description: description, location: location, url: image)
    }
}
