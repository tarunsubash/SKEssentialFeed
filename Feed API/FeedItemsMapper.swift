//
//  FeedItemsMapper.swift
//  SKEssentialFeed
//
//  Created by Subash on 17/11/23.
//

internal class FeedItemsMapper {
    private struct Root: Decodable {
        let items: [Item]
    }

    private struct Item: Decodable {
        public let uuid: UUID
        public let description: String?
        public let location: String?
        public let image: URL
        
        var item: FeedItem {
            return FeedItem(uuid: uuid, description: description, location: location, imageURL: image)
        }
    }
    
    private static var OK_200: Int { return 200 }
    internal static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [FeedItem] {
        guard response.statusCode == OK_200 else {
            throw RemoteFeedLoader.Error.invalidData
        }
        return try JSONDecoder().decode(Root.self, from: data).items.map { $0.item }
    }
}
