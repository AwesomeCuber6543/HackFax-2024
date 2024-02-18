//
//  Endpoints.swift
//  HackFax-AAAAT
//
//  Created by yahia salman on 2/17/24.
//


import Foundation

enum Endpoint {
    
   
    case getNumberCrunches(path: String = "/get_number_crunches")
    case getNumberSquats(path: String = "/get_number_squats")
    
    var request: URLRequest? {
        guard let url = self.url else {return nil}
        
        var request = URLRequest(url: url)
        request.httpMethod = self.httpMethod
        request.addValues(for: self)
        request.httpBody = self.httpBody
        return request
    }
    
    private var url: URL? {
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.baseURL
        components.port = Constants.port
        components.path = self.path
        return components.url
    }
    
    private var path: String {
        switch self {
        case .getNumberCrunches(let path),
                .getNumberSquats(let path):
            return path
        }
    }
    
    private var httpMethod: String {
        switch self {
        case .getNumberCrunches,
                .getNumberSquats:
            return HTTP.Method.get.rawValue
            
        }
    }
    
    private var httpBody: Data? {
        switch self {

        case .getNumberSquats:
            return nil
            
        case .getNumberCrunches:
            return nil
        
        }
    
        
    }
}

extension URLRequest {
    mutating func addValues(for endpoint: Endpoint) {
        switch endpoint{
        case .getNumberCrunches,
                .getNumberSquats:
            self.setValue(HTTP.Headers.Value.applicationJson.rawValue, forHTTPHeaderField: HTTP.Headers.Key.contentType.rawValue)
        }
        
    }
}

