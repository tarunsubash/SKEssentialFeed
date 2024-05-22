//
//  FeedItemsMapper.swift
//  SKEssentialFeed
//
//  Created by Subash on 17/11/23.
//

internal class FeedItemsMapper {
    private struct Root: Decodable {
        let items: [RemoteFeedItem]
    }
    
    private static var OK_200: Int { return 200 }
   
    internal static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [FeedImage] {
        
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
