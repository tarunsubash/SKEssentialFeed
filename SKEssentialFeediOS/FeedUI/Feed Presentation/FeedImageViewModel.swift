//
//  FeedImageViewModel.swift
//  SKEssentialFeediOS
//
//  Created by Subash on 31/05/25.
//

import SKEssentialFeed
import Foundation

struct FeedImageViewModel<Image> {
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool
    
    var hasLocation: Bool {
        return location != nil
    }
}
