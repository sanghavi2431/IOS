//
//  NetworkEnvironment.swift
//  Woloo
//
//  Created by DigitalFlake Kapil Dongre on 20/02/23.
//

import Foundation
import Alamofire
import Combine

enum NetworkEnvironment {
    case dev
    case staging
    case production
    case newStagingDF
    case local
}

// MARK: Network Manager
class NetworkManager : NSObject{
    
    static let networkEnvironment: NetworkEnvironment = .production
    var services = NetworkService();
    var parameters = Parameters()
    var headers = HTTPHeaders()
    var method: HTTPMethod!
    var url :String! = baseURL
    var encoding: ParameterEncoding! = JSONEncoding.default
 
    init(data: [String:Any] = [:], headers: [String:String] = [:], url :String?, service :services? = nil, method: HTTPMethod = .post, isJSONRequest: Bool = true){
        super.init()
//        - (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response for chucker
        data.forEach{parameters.updateValue($0.value, forKey: $0.key)}
        headers.forEach({self.headers.add(name: $0.key, value: $0.value)})
        if url == nil, service != nil{
            self.url += service!.rawValue
        }else{
            self.url = url
        }
        if !isJSONRequest{
            encoding = URLEncoding.default
        }
        self.method = method
        print("Service: \(service?.rawValue ?? self.url ?? "") \n data: \(parameters)<------")
    }
    
    func executeQuery<T>(completion: @escaping (Result<T, Error>) -> Void) where T: Codable {
            AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseData(completionHandler: {response in
            switch response.result{
            case .success(let res):
                if let code = response.response?.statusCode{
                    switch code {
                    case 200...299:
                        do {
                            completion(.success(try JSONDecoder().decode(T.self, from: res)))
                        } catch let error {
                            print(String(data: res, encoding: .utf8) ?? "nothing received--------->")
                            
                            // Try to extract error message from response
                            if let errorMessage = NetworkManager.extractErrorMessage(from: res) {
                                let networkError = NetworkError(message: errorMessage, underlyingError: error, statusCode: code)
                                completion(.failure(networkError))
                            } else {
                                completion(.failure(error))
                            }
                        }
                    default:
                        // Non-2xx status code, try to extract error message
                        let errorMessage = NetworkManager.extractErrorMessage(from: res) ?? "An error occurred. Please try again."
                        let networkError = NetworkError(message: errorMessage, statusCode: code)
                        completion(.failure(networkError))
                    }
                }
                break
            case .failure(let error):
                print("Network Manager Response: \(response)")
                completion(.failure(error))
                break
            }
        })
    }
}

struct ErrorBody: Codable {
    
    let error: ErrorResponse?
    
    enum CodingKeys: String, CodingKey{
        case error
    }
    
    struct ErrorResponse: Codable {
        let message: String
        
        enum CodingKeys: String, CodingKey{
            case message
        }
    }
}

// MARK: - Custom Network Error with Message
struct NetworkError: Error {
    let message: String
    let underlyingError: Error?
    let statusCode: Int?
    
    init(message: String, underlyingError: Error? = nil, statusCode: Int? = nil) {
        self.message = message
        self.underlyingError = underlyingError
        self.statusCode = statusCode
    }
    
    var localizedDescription: String {
        return message
    }
}

// MARK: - Error Message Extractor
extension NetworkManager {
    /// Extracts error message from response data
    static func extractErrorMessage(from data: Data) -> String? {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                // Try to get message from various possible keys
                if let message = json["message"] as? String {
                    return message
                }
                if let error = json["error"] as? [String: Any], let message = error["message"] as? String {
                    return message
                }
                if let errors = json["errors"] as? [String: Any], let message = errors["message"] as? String {
                    return message
                }
            }
        } catch {
            print("Failed to parse error response: \(error)")
        }
        return nil
    }
}

/**
 *check connectivity
*/
class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

