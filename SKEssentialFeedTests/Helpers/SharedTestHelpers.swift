//
//  SharedTestHelpers.swift
//  SKEssentialFeedTests
//
//  Created by Subash on 24/05/24.
//

import Foundation
import SKEssentialFeed

func anyError() -> NSError { NSError(domain: "any error", code: 0) }

func anyURL() -> URL { return URL(string: "http://any-url.com")! }
