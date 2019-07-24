//
//  DYVideoDetailService.swift
//  Service
//
//  Created by Diana Ivascu on 7/24/19.
//  Copyright © 2019 Diana Melita. All rights reserved.
//

import Foundation
import Model

private struct VideoDetailInfo: Decodable {
    let items: [VideoDetails]
}

public class DYVideoDetailService: VideoDetailService {
    
    public init() {}
    
    private static let baseUrl: URL! = URL(string: "https://www.googleapis.com/youtube/v3/videos")
    private static let apiKey = "AIzaSyD3gOMnpD0DsnNVJPlSxVy2-HpT8109Alo"
    
    public func retrieveVideoDetails(for videoId: String, completion: @escaping (VideoDetails?, Error?) -> Void) {
        
        guard let videoDetailsUrl = constructVideoRetrievalUrl(for: videoId) else {
            completion(nil, ServiceError.urlBuilderFail(details: "Could not build URL for video ID \(videoId)"))
            return
        }

        let urlRequest = URLRequest(url: videoDetailsUrl)
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            guard let data = data else {
                completion(nil, ServiceError.noDataRetrieved(details: "No data could be retrieved for request \(urlRequest)"))
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let videoArray = try jsonDecoder.decode(VideoDetailInfo.self, from: data)
                completion(videoArray.items.first, nil)
            } catch {
                
                completion(nil, ServiceError.malformedData(details: "Malformed data was received for \(urlRequest)"))
            }
        }
        dataTask.resume()
    }
    
    private func constructVideoRetrievalUrl(for videoId: String) -> URL? {
        let partElement = URLQueryItem(name: "part", value: "contentDetails, snippet")
        let videoIdElement = URLQueryItem(name: "id", value: "\(videoId)")
        let keyElement = URLQueryItem(name: "key", value: DYVideoDetailService.apiKey)
        
        var urlComponents = URLComponents(url: DYVideoDetailService.baseUrl,
                                          resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [partElement, videoIdElement, keyElement]
        return urlComponents?.url
    }
}
