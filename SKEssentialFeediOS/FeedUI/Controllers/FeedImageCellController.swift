//
//  FeedImageCellController.swift
//  SKEssentialFeediOS
//
//  Created by Subash on 31/01/25.
//

import UIKit
import SKEssentialFeed

public final class FeedImageCellController {
    private var task: FeedImageDataLoaderTask?
    private var model: FeedImage
    private var imageLoader: FeedImageDataLoader
    
    init(model: FeedImage, imageLoader: FeedImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    func view() -> UITableViewCell {
        let cell = FeedImageCell()
        cell.locationContainer.isHidden = (model.location == nil)
        cell.locationLabel.text = model.location
        cell.descriptionLabel.text = model.description
        cell.feedImageView.image = nil
        cell.feedImageRetryButton.isHidden = true
        cell.feedImageContainer.startShimmering()
        
        let loadImage = { [weak self, weak cell] in
            guard let self = self else { return }
            
            self.task = self.imageLoader.loadImageData(from: model.url) { [weak cell] result in
                let data = try? result.get()
                let image = data.map(UIImage.init) ?? nil
                cell?.feedImageView.image = image
                cell?.feedImageRetryButton.isHidden = (image != nil)
                cell?.feedImageContainer.stopShimmering()
            }
        }
        
        cell.onRetry = loadImage
        loadImage()
        
        return cell
    }
    
    func preload() {
        task = imageLoader.loadImageData(from: model.url, completion: { _ in })
    }
    
    func cancelLoad() {
        task?.cancel()
    }
}
