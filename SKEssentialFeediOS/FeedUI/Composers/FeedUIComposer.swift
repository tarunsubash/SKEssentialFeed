//
//  FeedUIComposer.swift
//  SKEssentialFeediOS
//
//  Created by Subash on 31/01/25.
//

import UIKit
import SKEssentialFeed

public final class FeedUIComposer {
    public static func feedComposeWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let refreshController = FeedRefreshViewController(feedLoader: feedLoader)
        let feedController = FeedViewController(refreshController: refreshController)
        refreshController.onRefresh = adaptFeedToCellControllers(forwardingTo: feedController, loader: imageLoader)
        return feedController
    }
    
    private static func adaptFeedToCellControllers(forwardingTo controller: FeedViewController, loader: FeedImageDataLoader) -> ([FeedImage]) -> Void {
        return { [weak controller] feed in
            controller?.tableModel = feed.map({ model in
                FeedImageCellController(model: model, imageLoader: loader)
            })
            
        }
    }
}
