//
//  DecoderModified.swift
//  Sawin
//
// 
//

import UIKit

extension Decodable{
    static func decode<T : Decodable>(_ data : Data) -> T? {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch let err {
            print(err)
            //SSLog(message: "DecoderModifiedError>>\(err)")
        }
        return nil
    }
    static func decodeArray<T : Decodable>(_ data : Data) -> T? {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch let err {
            print(err)
            //SSLog(message: "DecoderModifiedError>>\(err)")
        }
        return nil
    }
}
