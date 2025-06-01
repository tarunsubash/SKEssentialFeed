//
//  UITableView+Dequeueing.swift
//  SKEssentialFeediOS
//
//  Created by Subash on 01/06/25.
//

import Foundation
import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
