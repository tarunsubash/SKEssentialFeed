//
//  FeedImageViewModel.swift
//  SKEssentialFeediOS
//
//  Created by Subash on 31/05/25.
//

import SKEssentialFeed
import Foundation

public final class FeedImageViewModel<Image> {
    typealias Observer<T> = (T) -> Void
    
    private var task: FeedImageDataLoaderTask?
    private var model: FeedImage
    private var imageLoader: FeedImageDataLoader
    private let imageTransformer: (Data) -> Image?
    
    init(model: FeedImage,
         imageLoader: FeedImageDataLoader,
         imageTransformer: @escaping (Data) -> Image?) {
        self.model = model
        self.imageLoader = imageLoader
        self.imageTransformer = imageTransformer
    }
    
    var description: String? { model.description }
    
    var location: String? { model.location }
    
    var hasLocation: Bool { location != nil }
    
    var onImageLoad: Observer<Image>?
    var onImageLoadingStateChange: Observer<Bool>?
    var onShouldRetryImageLoadStateChange: Observer<Bool>?
    
    func loadImageData() {
        onImageLoadingStateChange?(true)
        onShouldRetryImageLoadStateChange?(false)
        task = imageLoader.loadImageData(from: model.url) { [weak self] result in
            self?.handle(result)
        }
    }
    
    private func handle(_ result: FeedImageDataLoader.Result) {
        if let image = (try? result.get()).flatMap(imageTransformer) {
            onImageLoad?(image)
        } else {
            onShouldRetryImageLoadStateChange?(true)
        }
        onImageLoadingStateChange?(false)
    }
    
    func cancelImageDataLoad() {
        task?.cancel()
        task = nil
    }
    
}
