//
//  URLSessionHTTPClientTests.swift
//  SKEssentialFeedTests
//
//  Created by Subash on 22/01/24.
//

import XCTest
import SKEssentialFeed

class URLSessionHTTPClient {
    init(session: URLSession) {
        self.session = session
    }
    
    private let session: URLSession
    
    func get(from url: URL,  completion: @escaping ((HTTPClientResult) -> Void)) {
        session.dataTask(with: url) {_, _, error in
            if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}

final class URLSessionHTTPClientTests: XCTestCase {
    
    func test_getFromUrl_resumesADataTaskWithURL() {
        let url = URL(string: "https://any-url.com")!
        let session = URLSessionSpy()
        let sut = URLSessionHTTPClient(session: session)
        let task = URLSessionDataTaskSpy()
        session.stub(url: url, task: task)
        
        sut.get(from: url) {_ in}
        
        XCTAssertEqual(task.resumeCallCount, 1)
    }

    func test_getFromURL_failsOnRequestError() {
        let url = URL(string: "https://any-url.com")!
        let session = URLSessionSpy()
        let sut = URLSessionHTTPClient(session: session)
        let error = NSError(domain: "Invalid Error", code: 400)
        
        session.stub(url: url, error: error)
        let expection = expectation(description: "wait for completion")
        
        sut.get(from: url) { result in
            switch result {
            case let .failure(recievedError as NSError):
                XCTAssertEqual(error, recievedError)
            default:
                XCTFail("Expected failure with error \(error) got \(result) instead")
            }
            expection.fulfill()
        }
        
        wait(for: [expection], timeout: 1.0)
    }
    
    
    private class URLSessionSpy: URLSession {
        private var stubs: [URL: Stub] = [:]
        
        private struct Stub {
            let task: URLSessionDataTask
            let error: Error?
        }
        
        func stub(url: URL, task: URLSessionDataTask = FakeURLSessionDataTask(), error: Error? = nil) {
            stubs[url] = Stub(task: task, error: error)
        }
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            guard let stub = stubs[url] else {
                fatalError("Could not find stub for \(url)")
            }
            completionHandler(nil, nil, stub.error)
            return stub.task
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
