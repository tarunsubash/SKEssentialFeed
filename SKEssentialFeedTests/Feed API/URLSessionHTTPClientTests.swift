//
//  URLSessionHTTPClientTests.swift
//  SKEssentialFeedTests
//
//  Created by Subash on 22/01/24.
//

import XCTest

class URLSessionHTTPClient {
    init(session: URLSession) {
        self.session = session
    }
    
    private let session: URLSession
    
    func get(from url: URL) {
        session.dataTask(with: url) {_, _, _ in }.resume()
    }
}

final class URLSessionHTTPClientTests: XCTestCase {
    
    func test_getFromUrl_resumesADataTaskWithURL() {
        let url = URL(string: "https://any-url.com")!
        let session = URLSessionSpy()
        let sut = URLSessionHTTPClient(session: session)
        let task = URLSessionDataTaskSpy()
        session.stub(url: url, task: task)
        
        sut.get(from: url)
        
        XCTAssertEqual(task.resumeCallCount, 1)
    }

    private class URLSessionSpy: URLSession {
        var stubs: [URL: URLSessionDataTask] = [:]
        func stub(url: URL, task: URLSessionDataTask) {
            stubs[url] = task
        }
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            return stubs[url] ?? FakeURLSessionDataTask()
        }
    }
    
    private class FakeURLSessionDataTask: URLSessionDataTask {
        override func resume() {}
    }
    
    private class URLSessionDataTaskSpy: URLSessionDataTask {
        var resumeCallCount = 0
        
        override func resume() {
            resumeCallCount += 1
        }
    }
}
