//
//  NetworkingManager.swift
//  Netflix Clone
//
//  Created by Suguru on 10/22/22.
//

import Foundation

class NetworkingManager {
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
    }
    
    static func download(url: URL) async throws -> Data? {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            return handleURLResponse(data: data, response: response)
        }
    }
    
    static func handleURLResponse(data: Data?, response: URLResponse?) -> Data? {
        guard
            let data = data,
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            return nil
        }
        return data
    }
}
