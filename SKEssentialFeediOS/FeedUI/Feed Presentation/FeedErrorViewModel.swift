//
//  FeedErrorViewModel.swift
//  SKEssentialFeed
//
//  Created by Subash on 03/06/25.
//


struct FeedErrorViewModel {
    let message: String?
    
    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: .none)
    }
    
    static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}
