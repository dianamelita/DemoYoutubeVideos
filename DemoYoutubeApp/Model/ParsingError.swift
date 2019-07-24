//
//  ParsingError.swift
//  Model
//
//  Created by Diana Ivascu on 7/24/19.
//  Copyright © 2019 Diana Melita. All rights reserved.
//

import Foundation

public enum ParsingError: Error {
    
    case dateConversionFailure(details: String)
}

extension ParsingError: LocalizedError {
    
    public var errorDescription: String? {
        
        switch self {
            
        case .dateConversionFailure(let details):
            
            return "Details: \(details)"
        }
    }
}
