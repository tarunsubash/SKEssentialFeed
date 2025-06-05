//
//  FeedErrorViewModel.swift
//  SKEssentialFeed
//
//  Created by Subash on 05/06/25.
//


public struct FeedErrorViewModel {
    public let message: String?
    
    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: .none)
    }
    
    static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}