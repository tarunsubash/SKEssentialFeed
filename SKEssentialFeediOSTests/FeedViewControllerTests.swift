//
//  FeedViewControllerTests.swift
//  SKEssentialFeediOSTests
//
//  Created by Subash on 11/07/24.
//

import XCTest

final class FeedViewController {
    init(loader: FeedViewControllerTests.LoaderSpy) {
        
    }
}

final class FeedViewControllerTests: XCTestCase {
    func test_init_doesnotLoadFeed() {
        let loader = LoaderSpy()
        
        _ = FeedViewController(loader: loader)
        
    }
    
    class LoaderSpy {
        private(set) var loadCallCount: Int = 0
    }
}
