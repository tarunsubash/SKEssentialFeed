//
//  FeedImageCell.swift
//  Prototype
//
//  Created by Subash on 10/07/24.
//

import UIKit

final class FeedImageCell: UITableViewCell {
    @IBOutlet private(set) weak var locationContainer: UIStackView!
    @IBOutlet private(set) weak var locationLabel: UILabel!
    @IBOutlet private(set) weak var feedImageView: UIImageView!
    @IBOutlet private(set) weak var descriptionLabel: UILabel!
}
