//
//  XCTestCase+MemoryLeak.swift
//  SKEssentialFeedTests
//
//  Created by Subash on 02/02/24.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject,
                                     file: StaticString = #filePath,
                                     line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance Should have been deallocated. Potential Memory Leak", file: file, line: line)
        }
    }
}
