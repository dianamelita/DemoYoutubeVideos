//
//  Video.swift
//  Model
//
//  Created by Diana Ivascu on 7/24/19.
//  Copyright © 2019 Diana Melita. All rights reserved.
//

import Foundation

public struct Video {
    
    public let id: String
    public let title: String
    public let thumbnail: URL
}

extension Video: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case id
        case snippet
    }
    
    private enum IdCodingKey: String, CodingKey {
        case videoId
    }
    
    private enum SnippetCodingKeys: String, CodingKey {
        case title
        case thumbnails
    }
    
    private enum ThumbnailCodingKey: String, CodingKey {
        case defaultThumbnail = "default"
    }
    
    private enum DefaultThumbnailCodingKey: String, CodingKey {
        case url
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let idContainer = try container.nestedContainer(keyedBy: IdCodingKey.self, forKey: .id)
        let snippetContainer = try container.nestedContainer(keyedBy: SnippetCodingKeys.self, forKey: .snippet)
        id = try idContainer.decode(String.self, forKey: .videoId)
        title = try snippetContainer.decode(String.self, forKey: .title)
        
        let thumbnailsContainer = try snippetContainer.nestedContainer(keyedBy: ThumbnailCodingKey.self, forKey: .thumbnails)
        let defaultThumbnailContainer = try thumbnailsContainer.nestedContainer(keyedBy: DefaultThumbnailCodingKey.self, forKey: .defaultThumbnail)
        
        thumbnail = try defaultThumbnailContainer.decode(URL.self, forKey: .url)
    }
}
