//
//  FeedItem.swift
//  SKEssentialFeed
//
//  Created by Subash on 23/10/23.
//

import Foundation

public struct FeedItem: Equatable {
    let uuid: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
