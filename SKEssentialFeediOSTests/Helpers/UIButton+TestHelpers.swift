//
//  UIButton+TestHelpers.swift
//  SKEssentialFeediOSTests
//
//  Created by Subash on 30/01/25.
//

import UIKit

extension UIButton {
    func simulateTap() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .touchUpInside)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
