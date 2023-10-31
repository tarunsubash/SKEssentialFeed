//
//  RemoteFeedLoader.swift
//  SKEssentialFeed
//
//  Created by Subash on 31/10/23.
//

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (Error) -> Void)
}

public class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
    }
    
    public init(url: URL,
                client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (Error) -> Void) {
        client.get(from: url) { error in
            completion(.connectivity)
        }
    }
}
