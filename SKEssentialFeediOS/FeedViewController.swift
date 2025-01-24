//
//  FeedViewController.swift
//  SKEssentialFeediOS
//
//  Created by Subash on 23/01/25.
//

import UIKit
import SKEssentialFeed

final public class FeedViewController: UITableViewController {
    private var loader: FeedLoader?
    
    private var tableModel = [FeedImage]()
    
    public convenience init(loader: FeedLoader) {
       self.init()
       self.loader = loader
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
    }

    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        load()
    }
    
    @objc private func load() {
        refreshControl?.beginRefreshing()
        loader?.load(completion: { [weak self] result in
            switch result {
            case let .success(feed):
                self?.tableModel = (try? result.get()) ?? []
                self?.tableView.reloadData()
                self?.refreshControl?.endRefreshing()
            case .failure: break
            }
        })
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = tableModel[indexPath.row]
        let cell = FeedImageCell()
        cell.locationContainer.isHidden = (cellModel.location == nil)
        cell.locationLabel.text = cellModel.location
        cell.descriptionLabel.text = cellModel.description
        return cell
    }
}
