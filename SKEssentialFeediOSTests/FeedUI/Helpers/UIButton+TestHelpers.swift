//
//  UIButton+TestHelpers.swift
//  SKEssentialFeediOSTests
//
//  Created by Subash on 30/01/25.
//

import UIKit

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
