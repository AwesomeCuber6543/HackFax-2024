//
//  HTTP.swift
//  HackFax-AAAAT
//
//  Created by yahia salman on 2/17/24.
//

import Foundation

enum HTTP {
    
    enum Method: String{
        case get = "GET"
        case post = "POST"
    }
    
    enum Headers {
        
        enum Key: String {
            case contentType = "Content-Type"
        }
        
        enum Value: String {
            case applicationJson = "application/json"
        }
    }
}
