//
//  VideosViewController.swift
//  DemoYoutubeApp
//
//  Created by Diana Ivascu on 7/24/19.
//  Copyright © 2019 Diana Melita. All rights reserved.
//

import UIKit
import Model
import Service

class VideosViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private var videos: [Video] = []
    private var videoService: VideoService = DYVideoService()
    private let channelId = "UC_A--fhX5gea0i4UtpD99Gg"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getAllVideos), for: .valueChanged)
        
        tableView.refreshControl = refreshControl
        tableView.refreshControl?.beginRefreshing()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        getAllVideos()
    }
    
    @objc private func getAllVideos() {
        videoService.retrieveVideos(for: channelId) { (videos, error) in
           
            DispatchQueue.main.async {
                
                self.tableView.refreshControl?.endRefreshing()
                if let _ = error {
                    self.tableView.displayMessage("No GMBN Videos found. Please try again later.")
                    return
                }
                self.tableView.hideMessageLabel()
                
                self.videos = videos ?? []
                self.tableView.reloadData()
            }
        }
    }
}

extension VideosViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableCell = tableView.dequeueReusableCell(withIdentifier:
            "VideoCell", for: indexPath) as? VideoCell else {
                return UITableViewCell()
        }
        
        let video = videos[indexPath.row]
        tableCell.update(with: video)
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let videoDetailsVC = storyboard?.instantiateViewController(withIdentifier: "VideoDetails") as? VideoDetailsViewController else { return }
        
        let videoTapped = videos[indexPath.row]
        videoDetailsVC.videoId = videoTapped.id
        navigationController?.pushViewController(videoDetailsVC, animated: true)
    }
}
