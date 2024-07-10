//
//  HTTPClient.swift
//  SKEssentialFeed
//
//  Created by Subash on 17/11/23.
//

public protocol HTTPClient {
    typealias Result = Swift.Result<(HTTPURLResponse, Data), Error>
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func get(from url: URL, completion: @escaping (Result) -> Void)
}
