//
//  DYVideoService.swift
//  Service
//
//  Created by Diana Ivascu on 7/24/19.
//  Copyright © 2019 Diana Melita. All rights reserved.
//

import Foundation
import Model

private struct VideoInfo: Decodable {
    let items: [Video]
    let nextPageToken: String?
}

public class DYVideoService: VideoService {
    
    private static let baseUrl: URL! = URL(string: "https://www.googleapis.com/youtube/v3/search")
    private static let apiKey = "AIzaSyD3gOMnpD0DsnNVJPlSxVy2-HpT8109Alo"
    
    private let channelId: String
    private var nextPageToken: String?
    
    public init(channelId: String) {
        self.channelId = channelId
    }
    
    public func retrieveVideos(completion: @escaping ([Video]?, Error?) -> Void) {
        guard let videoRetrievalUrl = constructVideoRetrievalUrl(for: channelId) else {
            completion(nil, ServiceError.urlBuilderFail(details: "Could not build URL for channel ID \(channelId)"))
            return
        }

        let urlRequest = URLRequest(url: videoRetrievalUrl)
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
                let videoArray = try jsonDecoder.decode(VideoInfo.self, from: data)
                self.nextPageToken = videoArray.nextPageToken
                completion(videoArray.items, nil)
            } catch {
                
                completion(nil, ServiceError.malformedData(details: "Malformed data was received for \(urlRequest)"))
            }
        }
        dataTask.resume()
    }
    
    private func constructVideoRetrievalUrl(for channelId: String) -> URL? {
        let partElement = URLQueryItem(name: "part", value: "snippet")
        let maxResultsElement = URLQueryItem(name: "maxResults", value: "10")
        let channelIdElement = URLQueryItem(name: "channelId", value: "\(channelId)")
        let keyElement = URLQueryItem(name: "key", value: DYVideoService.apiKey)
        
        var urlComponents = URLComponents(url: DYVideoService.baseUrl,
                                          resolvingAgainstBaseURL: true)
        
        urlComponents?.queryItems = [partElement, maxResultsElement, channelIdElement, keyElement]
        if let nextPageToken = nextPageToken {
            let nextPageElement = URLQueryItem(name: "pageToken", value: "\(nextPageToken)")
            urlComponents?.queryItems?.append(nextPageElement)
        }
        return urlComponents?.url
    }
}
