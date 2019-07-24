//
//  VideoDetails.swift
//  Model
//
//  Created by Diana Ivascu on 7/24/19.
//  Copyright © 2019 Diana Melita. All rights reserved.
//

import Foundation

public struct VideoDetails {
    
    public let id: String
    public let title: String
    public let description: String
    public let thumbnail: URL
    public let datePublished: Date
    public let duration: String
    
    private static var dateFormatter: DateFormatter {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        
        return dateFormatter
    }
}

extension VideoDetails: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case id
        case snippet
        case contentDetails
    }
    
    private enum SnippetCodingKeys: String, CodingKey {
        case title
        case description
        case thumbnails
        case datePublished = "publishedAt"
    }
    
    private enum ThumbnailsCodingKey: String, CodingKey {
        case standard
    }
    
    private enum MediumThumbnailCodingKey: String, CodingKey {
        case url
    }
    
    private enum ContentDetailsCodingKey: String, CodingKey {
        case duration
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)

        let snippetContainer = try container.nestedContainer(keyedBy: SnippetCodingKeys.self, forKey: .snippet)

        let contentDetailsContainer = try container.nestedContainer(keyedBy: ContentDetailsCodingKey.self, forKey: .contentDetails)
        duration = try contentDetailsContainer.decode(String.self, forKey: .duration)

        title = try snippetContainer.decode(String.self, forKey: .title)
        description = try snippetContainer.decode(String.self, forKey: .description)
        let datePublishedString = try snippetContainer.decode(String.self, forKey: .datePublished)
        guard let datePublishedFormatted = VideoDetails.dateFormatter.date(from: datePublishedString) else {
            throw ParsingError.dateConversionFailure(details: "Failed to create date from string \(datePublishedString) using format \(VideoDetails.dateFormatter.dateFormat ?? "none")")
        }
        datePublished = datePublishedFormatted

        let thumbnailsContainer = try snippetContainer.nestedContainer(keyedBy: ThumbnailsCodingKey.self, forKey: .thumbnails)
        let standardThumbnailContainer = try thumbnailsContainer.nestedContainer(keyedBy: MediumThumbnailCodingKey.self, forKey: .standard)
        thumbnail = try standardThumbnailContainer.decode(URL.self, forKey: .url)
    }
}
