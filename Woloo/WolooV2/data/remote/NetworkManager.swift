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
    
    static let networkEnvironment: NetworkEnvironment = .staging
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
                            completion(.failure(error))
                        }
                    default:
                     let error = NSError(domain: response.debugDescription, code: code, userInfo: response.response?.allHeaderFields as? [String: Any])
                        completion(.failure(error))
//                        print("FAILURE----")
//                        let json = String(data: res, encoding: .utf8)
//                        let data = json?.data(using: .utf8)
//                        let errorbody = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
//                        //print("Debug description \(response.debugDescription)")
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

/**
 *check connectivity
*/
class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

