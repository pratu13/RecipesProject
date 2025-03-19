//
//  NetworkingManager.swift
//  RecipesProject
//
//  Created by Pratyush on 3/11/25.
//

import Foundation
import Combine

class NetworkingManager {
    
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(let url): return "Bad response from \(url.absoluteString)"
            case .unknown: return "Unknown error"
            }
        }
    }
    
    private init() { }
    
    /// Network Managers download api
    /// - Parameter endpoint: Endpoint indicating the end url to donwload
    /// - Returns: a result with the data or any network error
    static func downloadData(from endpoint: RecipesEndpoint) async -> Result<Data, NetworkingError> {
        do {
            let (data, response) = try await URLSession.shared.data(from: endpoint.url)
            let validatedData = try handleURLResponse(data: data, response: response, url: endpoint.url)
            return .success(validatedData)
        } catch {
            return .failure(.unknown)
        }
    }
    
    /// Validates the HTTP response to ensure a successful status code.
    private static func handleURLResponse(data: Data, response: URLResponse, url: URL) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkingError.badURLResponse(url: url)
        }
        return data
    }
}
