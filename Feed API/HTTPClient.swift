//
//  HTTPClient.swift
//  SKEssentialFeed
//
//  Created by Subash on 17/11/23.
//

public enum HTTPClientResult {
    case success(HTTPURLResponse, Data)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
