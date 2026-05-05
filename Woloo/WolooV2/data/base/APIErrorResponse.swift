//
//  APIErrorResponse.swift
//  Woloo
//
//  Created by CEPL on 07/01/26.
//

import Foundation

struct APIErrorResponse: Codable {
    let success: Bool?
    let message: String?
}


struct RecommendWolooErrorResponse: Codable {
    let success: Bool
    let message: String
}

extension Decodable {
    static func decode(_ data: Data) -> Self? {
        try? JSONDecoder().decode(Self.self, from: data)
    }
}
