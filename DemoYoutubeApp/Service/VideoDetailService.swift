//
//  VideoDetailService.swift
//  Service
//
//  Created by Diana Ivascu on 7/24/19.
//  Copyright © 2019 Diana Melita. All rights reserved.
//

import Foundation
import Model

public protocol VideoDetailService {
    
    func retrieveVideoDetails(for videoId: String, completion: @escaping (VideoDetails?, Error?) -> Void)
}
