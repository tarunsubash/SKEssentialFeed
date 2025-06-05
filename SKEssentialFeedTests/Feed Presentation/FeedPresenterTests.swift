//
//  FeedPresenterTests.swift
//  SKEssentialFeedTests
//
//  Created by Subash on 05/06/25.
//

import XCTest

final class FeedPresenter {
    init(view: Any) {
        
    }
}

final class FeedPresenterTests: XCTestCase {
    func test_init_doesNotSendAnyMessagesToView() {
        let view = ViewSpy()
        
        _ = FeedPresenter(view: view)
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    // MARK: Helpers
    
    private class ViewSpy {
        let messages = [Any]()
    }
}
