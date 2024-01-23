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
        session.dataTask(with: url) {_, _, _ in }
    }
}

final class URLSessionHTTPClientTests: XCTestCase {

    func test_getFromUrl_createsADataTaskWithURL() {
        let url = URL(string: "https://any-url.com")!
        let session = URLSessionSpy()
        let sut = URLSessionHTTPClient(session: session)
        
        sut.get(from: url)
        
        XCTAssertEqual(session.recievedUrls, [url])
    }

    private class URLSessionSpy: URLSession {
        var recievedUrls = [URL]()
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            recievedUrls.append(url)
            return FakeURLSessionDataTask()
        }
    }
    
    private class FakeURLSessionDataTask: URLSessionDataTask {}
}
