//
//  VideoCell.swift
//  DemoYoutubeApp
//
//  Created by Diana Ivascu on 7/24/19.
//  Copyright © 2019 Diana Melita. All rights reserved.
//

import UIKit
import Model
import SDWebImage

class VideoCell: UITableViewCell {

    @IBOutlet private weak var videoTitle: UILabel!
    @IBOutlet private weak var videoThumbnail: UIImageView!
    
    func update(with video: Video) {
        videoTitle.text = video.title
        videoThumbnail.sd_setImage(with: video.thumbnail, placeholderImage: nil)
    }
    
    override func prepareForReuse() {
        videoThumbnail.sd_cancelCurrentImageLoad()
    }
}
