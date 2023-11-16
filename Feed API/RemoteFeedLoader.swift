//
//  RemoteFeedLoader.swift
//  SKEssentialFeed
//
//  Created by Subash on 31/10/23.
//

public enum HTTPClientResult {
    case success(HTTPURLResponse, Data)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

public class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public enum Result: Equatable {
        case success([FeedItem])
        case failure(Error)
    }
    
    public init(url: URL,
                client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .success(response, data):
                if let root = try? JSONDecoder().decode(Root.self, from: data),
                   response.statusCode == 200 {
                    completion(.success(root.items.map({ $0.item
                    })))
                } else {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}

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
