//
//  DataService.swift
//  HackFax-AAAAT
//
//  Created by yahia salman on 2/17/24.
//

import Foundation


enum ServiceError: Error {
    case serverError(String)
    case unkown(String = "An unknown error occured.")
    case decodingError(String="Error parsing server response")
}

struct SuccessResponse: Decodable {
    let success: String
}

struct ErrorResponse: Decodable {
    let error: String
}

class DataService {
    
    static func getData(completion: @escaping (Result<DataArray, Error>) -> Void) {
        
        guard let request = Endpoint.getNumberSquats().request else { return }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(ServiceError.serverError(error.localizedDescription)))
                } else {
                    completion(.failure(ServiceError.unkown()))
                }
                
                return
            }
            
            let decoder = JSONDecoder()
            
            if let array = try? decoder.decode(DataArray.self, from: data) {
                completion(.success(array))
                return
            }
            else if let errorMessage = try? decoder.decode(ErrorResponse.self, from: data) {
                completion(.failure(ServiceError.serverError(errorMessage.error)))
                return
            }
            else {
                completion(.failure(ServiceError.decodingError()))
            }
            return
        }.resume()
        
    }
    
    
}
