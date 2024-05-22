//
//  FeedItemsMapper.swift
//  SKEssentialFeed
//
//  Created by Subash on 17/11/23.
//

struct RemoteFeedItem: Decodable {
    public let id: UUID
    public let description: String?
    public let location: String?
    public let image: URL
    
    var item: FeedItem {
        return FeedItem(uuid: id, description: description, location: location, imageURL: image)
    }
}

internal class FeedItemsMapper {
    private struct Root: Decodable {
        let items: [RemoteFeedItem]
    }
    
    private static var OK_200: Int { return 200 }
   
    internal static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [FeedItem] {
        
        return try JSONDecoder().decode(Root.self, from: data).items.map { $0.item }
    }
    
    internal static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.statusCode == OK_200,
        let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteFeedLoader.Error.invalidData
        }
        return root.items
    }
}
