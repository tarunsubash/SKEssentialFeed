//
//  URLSessionHTTPClientTests.swift
//  SKEssentialFeedTests
//
//  Created by Subash on 22/01/24.
//


import XCTest
import SKEssentialFeed

class URLSessionHTTPClientTests: XCTestCase {
    override func setUp() {
        super.setUp()
        URLProtocolStub.startInterceptingRequests()
    }
    
    override func tearDown() {
        super.tearDown()
        URLProtocolStub.stopInterceptingRequests()
    }
    
    func test_getFromURL_failsOnRequestError() {
        let requestError = NSError(domain: "any error", code: 1)
        
        guard let receivedError = resultForError(data: nil, response: nil, error: requestError) as? NSError else {
            XCTFail("Expected NSError")
            return
        }
        
        XCTAssertEqual(receivedError.domain, requestError.domain)
        XCTAssertEqual(receivedError.code, requestError.code)
        
    }
    
    func test_getFromURL_failsOnAllInvalidReperesentationCases() {
        
        XCTAssertNotNil(resultForError(data: nil, response: nil, error: nil))
        XCTAssertNotNil(resultForError(data: nil, response: nonHTTPURLResponse(), error: nil))
        XCTAssertNotNil(resultForError(data: anyData(), response: nil, error: nil))
        XCTAssertNotNil(resultForError(data: anyData(), response: nil, error: anyError()))
        XCTAssertNotNil(resultForError(data: nil, response: nonHTTPURLResponse(), error: anyError()))
        XCTAssertNotNil(resultForError(data: nil, response: anyHTTPURLResponse(), error: anyError()))
        XCTAssertNotNil(resultForError(data: anyData(), response: nonHTTPURLResponse(), error: anyError()))
        XCTAssertNotNil(resultForError(data: anyData(), response: anyHTTPURLResponse(), error: anyError()))
        XCTAssertNotNil(resultForError(data: anyData(), response: nonHTTPURLResponse(), error: nil))
    }
    
    func test_getFromURL_succeedsOnHTTPURLResponseWithData() {
        let data = anyData()
        let response = anyHTTPURLResponse()
        
        URLProtocolStub.stub(data: data, response: response, error: nil)
        let resultValues = resultForValues(data: data, response: response, error: nil)
        
        
        XCTAssertEqual(resultValues?.data, data)
        XCTAssertEqual(resultValues?.response.url, response.url)
        XCTAssertEqual(resultValues?.response.statusCode, response.statusCode)
    }
    
    func test_getFromURL_succeedsWithEmptyDataOnHTTPURLResponseWithNilData() {
        let response = anyHTTPURLResponse()
        let result = resultForValues(data: nil, response: response, error: nil)
        let emptyData = Data()
        XCTAssertEqual(result?.data, emptyData)
        XCTAssertEqual(result?.response.url, response.url)
        XCTAssertEqual(result?.response.statusCode, response.statusCode)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath,
                         line: UInt = #line) -> HTTPClient {
        let sut = URLSessionHTTPClient()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func resultForValues(data: Data?,
                                response: URLResponse?,
                                error: Error?,
                                file: StaticString = #file,
                                line: UInt = #line) -> (response: HTTPURLResponse, data: Data)? {
        let result = resultFor(data: data, response: response, error: error)
        switch result {
        case let .success((response, data)):
            return (response, data)
        default:
            XCTFail("Expected Success, got \(String(describing: result)) instead", file: file, line: line)
            return nil
        }
    }
    
    private func resultForError(data: Data?,
                                response: URLResponse?,
                                error: Error?,
                                file: StaticString = #file,
                                line: UInt = #line) -> Error? {
        let result = resultFor(data: data, response: response, error: error)
        switch result {
        case let .failure(error):
            return error
        default:
            XCTFail("Expected Failure, got \(String(describing: result)) instead", file: file, line: line)
            return nil
        }
    }
    
    private func resultFor(data: Data?,
                           response: URLResponse?,
                           error: Error?,
                           file: StaticString = #file,
                           line: UInt = #line) -> HTTPClient.Result? {
        URLProtocolStub.stub(data: data, response: response, error: error)
        let sut = makeSUT()
        let exp = expectation(description: "Wait for URL completion")
        
        var recievedResult: HTTPClient.Result?
        sut.get(from: anyURL()) { result in
            recievedResult = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return recievedResult
    }
    
    private func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
    private func anyData() -> Data { Data(count: 3) }
    
    private func anyError() -> NSError { NSError(domain: "any error", code: 0) }
    
    private func nonHTTPURLResponse() -> URLResponse {
        URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
    
    private func anyHTTPURLResponse() -> HTTPURLResponse {
        HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    
    private class URLProtocolStub: URLProtocol {
        private static var stubs: Stub?
        
        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
        }
        
        static func stub(data: Data?, response: URLResponse?, error: Error?) {
            stubs = Stub(data: data, response: response, error: error)
        }
        
        static func startInterceptingRequests() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        
        static func stopInterceptingRequests() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stubs = nil
        }
        
        override class func canInit(with request: URLRequest) -> Bool {
            return true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        override func startLoading() {
            
            
            if let data = URLProtocolStub.stubs?.data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            if let response = URLProtocolStub.stubs?.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let error = URLProtocolStub.stubs?.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        }
        
        override func stopLoading() {}
    }
    
}
