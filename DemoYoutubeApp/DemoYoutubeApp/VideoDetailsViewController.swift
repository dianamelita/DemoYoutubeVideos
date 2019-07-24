//
//  VideoDetailViewController.swift
//  DemoYoutubeApp
//
//  Created by Diana Ivascu on 7/24/19.
//  Copyright © 2019 Diana Melita. All rights reserved.
//

import UIKit
import Service
import SDWebImage

class VideoDetailsViewController: UIViewController {
    
    @IBOutlet private weak var videoTitleLabel: UILabel!
    @IBOutlet private weak var videoDescriptionLabel: UILabel!
    @IBOutlet private weak var videoImage: UIImageView!
    @IBOutlet private weak var datePublishedLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    
    public var videoId: String!
    
    private var videoDetailsService: VideoDetailService = DYVideoDetailService()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Video Details"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd yyyy, HH:mm"
        
        videoDetailsService.retrieveVideoDetails(for: videoId) { (videoDetails, error) in
            DispatchQueue.main.async {
                
                if let _ = error {
                    self.videoTitleLabel.text = "Error retrieving video details. Please try again later."
                    return
                }
                
                self.videoTitleLabel.text = videoDetails?.title
                self.videoDescriptionLabel.text = videoDetails?.description
                self.datePublishedLabel.text = dateFormatter.string(from: videoDetails?.datePublished ?? Date())
                if let duration = videoDetails?.duration {
                    self.durationLabel.text = self.getFormattedVideoDuration(duration)
                }
                self.videoImage.sd_setImage(with: videoDetails?.thumbnail, placeholderImage: nil)
            }
        }
    }
    
    private func getFormattedVideoDuration(_ duration: String) -> String {
        var durationText = ""
        let formattedDuration = DateComponents.durationFrom8601String(durationString: duration)
        
        if let hour = formattedDuration.hour {
            durationText += String(hour) + ":"
        }
        if let minute = formattedDuration.minute {
            durationText += String(minute) + ":"
        }
        if let second = formattedDuration.second {
            durationText += String(second)
        }
        return durationText
    }
}
