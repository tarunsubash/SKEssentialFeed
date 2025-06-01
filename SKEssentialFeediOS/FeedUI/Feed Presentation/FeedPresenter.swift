//
//  FeedPresenter.swift
//  SKEssentialFeediOS
//
//  Created by Subash on 31/05/25.
//

import SKEssentialFeed

protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}

final public class FeedPresenter {
    
    private let loadingView: FeedLoadingView
    private let feedView: FeedView
    
    init(loadingView: FeedLoadingView, feedView: FeedView) {
        self.loadingView = loadingView
        self.feedView = feedView
    }
    
    static var title: String {
        return "My Feed"
    }
    
    
    func didStartLoadingFeed() {
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }
    
    func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.display(FeedViewModel(feed: feed))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
    
    func didFinishLoadingFeed(with error: Error) {
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
}
