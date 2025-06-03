//
//  UIRefreshControl+Helpers.swift
//  SKEssentialFeediOS
//
//  Created by Subash on 03/06/25.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
