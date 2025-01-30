//
//  UIRefreshControl+TestHelpers.swift
//  SKEssentialFeediOSTests
//
//  Created by Subash on 30/01/25.
//

import UIKit

extension UIRefreshControl {
    func simulatePullToRefresh() {
        simulate(event: .valueChanged)
    }
}
