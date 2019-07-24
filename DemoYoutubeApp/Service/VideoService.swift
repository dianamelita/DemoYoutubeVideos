//
//  VideoService.swift
//  Service
//
//  Created by Diana Ivascu on 7/24/19.
//  Copyright © 2019 Diana Melita. All rights reserved.
//

import Foundation
import Model

public protocol VideoService {
    
    func retrieveVideos(completion: @escaping ([Video]?, Error?) -> Void)
}
