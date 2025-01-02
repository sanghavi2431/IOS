//
//  APIRestClient.swift
//
//  Created by Amzad-Khan on 21/08/19.
//  Copyright © 2019 Amzad Khan. All rights reserved.
//

import Foundation
import MobileCoreServices


protocol APIClientRequirement {
    
    func apiDataTask(url: URL, method:APIRestClient.HTTPMethod?, headers:[String:String]?, parameters:[String: Any]?, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask
    
    func apiUploadTask(url: URL, headers:[String:String]?, parameters:[String: String]?, files:[String: Any], result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionUploadTask
}


extension APIRestClient.APIServiceError : Equatable {
    
    static func ==(lhs: APIRestClient.APIServiceError, rhs: APIRestClient.APIServiceError) -> Bool  {
        switch (lhs, rhs) {
        case (.successWithError(_),  .successWithError(_)):
            return true
        case (.apiError, .apiError), (.invalidEndpoint, .invalidEndpoint), (.invalidResponse, .invalidResponse), (.noData, .noData), (.decodeError, .decodeError):
            return true
        default:
            return false
        }
    }
}


class APIRestClient {
    
    struct SharedKeys {
        static let apiRestClient = APIRestClient()
    }
    static let shared = SharedKeys.apiRestClient
    
    public enum APIServiceError: Error {
        
        case apiError // Error return by URLSession. //(Code , Message)
        case invalidEndpoint // Invalid API
        case invalidResponse // Invalid response received from server
        case noData // No data available
        case decodeError // Json parsing error //Data string //(Data string)
        case successWithError(WrapperModel)
        case networkError
    }
    
    enum HTTPMethod : String {
        case get, post
    }
    
    fileprivate let urlSession:URLSession
    fileprivate let sessionHandle = URLSessionHandle()
    
    var applicationState = UIApplication.State.active
    
    
    /*
     
     fileprivate let jsonDecoder: JSONDecoder = {
     let jsonDecoder = JSONDecoder()
     jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
     let dateFormatter = DateFormatter()
     dateFormatter.dateFormat = "yyyy-mm-dd"
     jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
     return jsonDecoder
     }()
     */
    
    private init() {
        
        let config = URLSessionConfiguration.default
        //config.httpAdditionalHeaders = ["User-Agent":"Legit Safari", "Authorization" : "Bearer key1234567"]
        config.timeoutIntervalForRequest = 60
        // use saved cache data if exist, else call the web API to retrieve
        config.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        
        //let session = URLSession(configuration: config)
        
        //SSL Pinning Delegate
        
        if API.environment == .beta {
            let session = URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
            self.urlSession = session
        }else {
            let session = URLSession(configuration: config, delegate: sessionHandle, delegateQueue: OperationQueue.main)
            self.urlSession = session
        }
        
        self.registerApplication()
    }
    func registerApplication() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(appBecomeBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appBecomeInactive), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    
    @objc func appBecomeBackground() {
        applicationState = .background
    }
    
    @objc func appBecomeActive() {
        applicationState = .active
    }
    
    @objc func appBecomeInactive() {
        applicationState = .inactive
    }
}

//----------------------------------------------------------------------------------------------------------------------//

extension APIRestClient {
    
    /// Create body of the `multipart/form-data` request
    ///
    /// - parameter parameters:   The optional dictionary containing keys and values to be passed to web service
    /// - parameter files:        The optional array of files (UIImage, [UIImage], URL, [URL]) the files to be uploaded
    /// - parameter boundary:     The `multipart/form-data` boundary
    ///
    /// - returns:                The `Data` of the body of the request
    
    fileprivate class func createMultiPartBody( parameters: [String: String]?, files:[String: Any]? = nil, boundary:String? =   APIRestClient.generateBoundaryString()) -> Data {
        
        var body = Data()
        if parameters != nil {
            for (key, value) in parameters! {
                body.append("--\(boundary!)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(value)\r\n")
            }
        }
        
        if let files = files {
            for (key, value) in files {
                if let image = value as? UIImage {
                    body.append(image: image, name: key, fileName: "\(key)_\(UUID().uuidString).jpg", boundary: boundary)
                    print("\(key)_\(UUID().uuidString).jpg")
                } else if let images = value as? [UIImage] {
                    for (index, item) in images.enumerated() {
                        body.append(image: item, name: "\(key)[\(index)]", fileName: "\(key)_\(UUID().uuidString).jpg", boundary: boundary)
                        print("\(key)_\(UUID().uuidString).jpg")
                    }
                    //Other File Code Later
                }else if let url  = value as? URL {
                    body.append(url: url, name: key, fileName: "\(key).\(url.pathExtension)", boundary: boundary)
                }else if let urls = value as? [URL] {
                    for (index, item) in urls.enumerated() {
                        body.append(url: item, name: "\(key)[\(index)]", fileName: "\(key)\(index).\(item.pathExtension)", boundary: boundary)
                    }
                }
            }
        }
        
        
        body.append("--\(boundary!)--\r\n")
        return body
    }
    
    /// Create boundary string for multipart/form-data request
    ///
    /// - returns:            The boundary string that consists of "Boundary-" followed by a UUID string.
    
    fileprivate static func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    /// Determine mime type on the basis of extension of a file.
    ///
    /// This requires `import MobileCoreServices`.
    ///
    /// - parameter path: The path of the file for which we are going to determine the mime type.
    ///
    /// - returns: Returns the mime type if successful. Returns `application/octet-stream` if unable to determine mime type.
    
    fileprivate static func mimeType(for path: String) -> String {
        let url = URL(fileURLWithPath: path)
        let pathExtension = url.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
}

//---------------------------------------------------------------------------------//

extension Data {
    
    /// Append string to Data
    ///
    /// Rather than littering my code with calls to `data(using: .utf8)` to convert `String` values to `Data`, this wraps it in a nice convenient little extension to Data. This defaults to converting using UTF-8.
    ///
    /// - parameter string: The string to be added to the `Data`.
    
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
    
    mutating func append(data:Data, name:String, fileName:String, mimeType: String, boundary:String? = APIRestClient.generateBoundaryString()) {
        
        // name : `key` for file parameter value
        self.append("--\(boundary!)\r\n")
        self.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n")
        self.append("Content-Type: \(mimeType)\r\n\r\n")
        self.append(data)
        self.append("\r\n")
    }
    
    mutating func append(url:URL, name:String, fileName:String, boundary:String? = APIRestClient.generateBoundaryString()) {
        
        let data = try! Data(contentsOf: url)
        let mimeType = APIRestClient.mimeType(for: url.path)
        
        // name : `key` for file parameter value
        self.append("--\(boundary!)\r\n")
        self.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n")
        self.append("Content-Type: \(mimeType)\r\n\r\n")
        self.append(data)
        self.append("\r\n")
    }
    
    mutating func append(image:UIImage, name:String, fileName:String, boundary:String? = APIRestClient.generateBoundaryString()) {
        
        // name : `key` for file parameter value
        let imageData = image.jpegData(compressionQuality: 0.6)
        
        self.append("--\(boundary!)\r\n")
        self.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n")
        self.append("Content-Type: image/jpg\r\n\r\n")
        self.append(imageData!)
        self.append("\r\n")
    }
}

//---------------------------------------------------------------------------------//
extension URLRequest {
    
    //Post request
    mutating func configureRquestHeader(headers:[String:String]?) {
        //For Headers
        if let headers = headers {
            for (key, value) in headers {
                self.addValue(value, forHTTPHeaderField: key)
            }
        }
    }
    
    mutating func configurePostRquest(params:[String:Any]?) {
        
        //Params:
        if let params = params, params.keys.count > 0 {
            do {
                let json = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                self.httpBody = json
            } catch let error as NSError {
                print(error.description)
                //JetMethods.printJet(message: error.description)
            }
        }
    }
    
    mutating func configureGetRquest(params:[String:String]?) {
        
        //Params:
        if let params = params, params.keys.count > 0 {
            var urlComponents = URLComponents(url: self.url!, resolvingAgainstBaseURL: false)
            let queryItems = params.map{
                return URLQueryItem(name: "\($0)", value: "\($1)")
            }
            urlComponents?.queryItems = queryItems
            self.url = urlComponents?.url
        }
    }
}

//---------------------------------------------------------------------------------//
// API Calling Helpers :
//---------------------------------------------------------------------------------//

extension URLSession {
    
    func dataTask(with url: URL, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: url) { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        }
    }
}

extension URLSession {
    
    // --  Default is POST request
    fileprivate func apiTask(url: URL, method:APIRestClient.HTTPMethod? = nil, headers:[String:String]? = nil, parameters:[String: Any]?, result: @escaping (_ result:Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        
        
        #if os(iOS)
        if (APIRestClient.shared.applicationState != UIApplication.State.background) && (APIRestClient.shared.applicationState != UIApplication.State.background) {
            //            DELEGATE.beginBackgroundTask()
        }
        #endif
        
        var request = URLRequest(url: url)
        
        if let method = method, method == .get {
            if let parameters = parameters as?  [String : String] {
                request.configureGetRquest(params: parameters)
                request.httpMethod = "GET"
            }else {
                //Get parameter value must be string for every key
            }
            
        }else {
            request.httpMethod = "POST"
            request.configurePostRquest(params: parameters)
        }
        
        if let headers = headers {
            request.configureRquestHeader(headers: headers)
        }
        
        return dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        }
    }
    
    fileprivate func apiUploadTask(url: URL, headers:[String:String]? = nil, parameters:[String: String]?, files:[String: Any], result: @escaping (_ result:Result<(URLResponse, Data), Error>) -> Void) -> URLSessionUploadTask {
        
        #if os(iOS)
        if (APIRestClient.shared.applicationState != UIApplication.State.background) && (APIRestClient.shared.applicationState != UIApplication.State.background) {
            //            DELEGATE.beginBackgroundTask()
        }
        #endif
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        if let headers = headers {
            request.configureRquestHeader(headers: headers)
        }
        let boundary = APIRestClient.generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let formData = APIRestClient.createMultiPartBody(parameters: parameters, files: files, boundary: boundary)
        
        return uploadTask(with: request, from: formData) { (data, response, error) in
            
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        }
    }
}



extension APIRestClient :  APIClientRequirement {
    
    func apiDataTask(url: URL, method: APIRestClient.HTTPMethod?, headers: [String : String]?, parameters: [String : Any]?, result: @escaping (_ result:Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        return self.urlSession.apiTask(url: url, method: method, headers: headers, parameters: parameters, result: result)
    }
    
    public func apiUploadTask(url: URL, headers:[String:String]? = nil, parameters:[String: String]?, files:[String: Any], result: @escaping (_ result:Result<(URLResponse, Data), Error>) -> Void) -> URLSessionUploadTask {
        return self.urlSession.apiUploadTask(url: url, headers: headers, parameters: parameters, files: files, result: result)
    }
    
}

//---------------- API Generic Helpers -----------------------------------------------


extension APIClient {
    
    fileprivate var jsonDecoder: JSONDecoder  {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }
    
    func apiRequest<T: Decodable>(params:[String:Any], url:URL, method: APIRestClient.HTTPMethod = .post, completion: @escaping (_ result:Result<T, APIRestClient.APIServiceError>) -> Void) {
        
        //let secondLastPath      = url.deletingLastPathComponent().lastPathComponent
        //let requestIdentifier   = "\(secondLastPath)/\(url.lastPathComponent)"
        
        var finalParam          = params
        //        finalParam["userCode"]  = APIClient.userCode
        finalParam["locale"]    = self.clientLocal.toJSON()
        finalParam["package_name"] = "in.woloo.app"
        //finalParam["package_name"] = Bundle.main.bundleIdentifier
        
        let finalParamJson      = finalParam.json()
        
        print("\nAPI URL: \(url.absoluteString)\n")
        print("Params: \(finalParam.json())\n")
        
        self.apiEncodedData(inputJsonString: finalParamJson) { (input, encKey, hmac,token) in
            let encodedParams = ["param1":input,"param2":encKey,"param3":hmac,"locale":self.clientLocal.toJSON()] as [String : Any]
            
            //TODO:  Need to configure header [Barear:token]
            //            print("\n📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍")
            //            print("\nAPI URL:👉 \(url.absoluteString)")
            //            print("\nAPI Params:👉 \(finalParam.json())\n")
            //            print("\nAPI Encoded Params:👉 \(encodedParams.json())")
            //            print("\n📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍")
            
            self.restClient.apiDataTask(url: url, method: method, headers: nil, parameters: encodedParams, result: { (result) in
                switch result {
                case .success(let (response, data)):
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                        completion(.failure(.invalidResponse))
                        return
                    }
                    
                    do {
                        let values = try self.jsonDecoder.decode(T.self, from: data)
                        completion(.success(values))
                    } catch {
                        completion(.failure(.decodeError))
                    }
                    break
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(.failure(.apiError))
                    break
                }
            }).resume()
            
            //self.jetProxyClient.createPostRequestWith(params: encodedParams, url: url, token: token, listener: self, extraParmIndex: "0")
        }
    }
    
    func apiUploadRequest<T: Decodable>(params:[String:Any], files:[String:Any], url:URL, completion: @escaping (_ result:Result<T, APIRestClient.APIServiceError>) -> Void) {
        
        let secondLastPath      = url.deletingLastPathComponent().lastPathComponent
        let requestIdentifier   = "\(secondLastPath)/\(url.lastPathComponent)"
        
        var finalParam          = params
        //        finalParam["userCode"]  = APIClient.userCode
        finalParam["locale"]    = self.clientLocal.toJSON()
        finalParam["package_name"] = "in.woloo.app"
        //finalParam["package_name"] = Bundle.main.bundleIdentifier
        let finalParamJson      = finalParam.json()
        
        print("\nAPI URL: \(url.absoluteString)\n")
        print("Params: \(finalParam.json())\n")
        
        self.apiEncodedData(inputJsonString: finalParamJson) { (input, encKey, hmac,token) in
            
            var encodedParams = ["param1":input,"param2":encKey,"param3":hmac] as [String:String]
            let multipartLocal = self.clientLocal.toJSON() as! [String:String]
            for (key, value) in multipartLocal {
                encodedParams["locale[\(key)]"] = value
            }
            //TODO:  Need to configure header [Barear:token]
            //            print("\n📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍")
            //            print("API URL:👉 \(url.absoluteString)")
            //            print("\nAPI Params:👉 \(finalParam.json())")
            //            print("\nAPI Encoded Params:👉 \(encodedParams.json())")
            //            print("\n📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍")
            
            
            
            let headers = [APIConstant.requestNameKey:requestIdentifier,APIConstant.contentTypeKey:APIConstant.contentTypeMultipartFormDataValue,APIConstant.authorization:"Bearer \(UserDefaultsManager.fetchAuthenticationToken())"]
            
            print("Header Param1:\n \(headers.json())")
            self.restClient.apiUploadTask(url: url, headers: headers, parameters: encodedParams, files: files, result: { (result) in
                switch result {
                case .success(let (response, data)):
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                        completion(.failure(.invalidResponse))
                        return
                    }
                    
                    do {
                        let values = try self.jsonDecoder.decode(T.self, from: data)
                        completion(.success(values))
                    } catch {
                        completion(.failure(.decodeError))
                    }
                    break
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(.failure(.apiError))
                    break
                }
            }).resume()
        }
    }
}





// ------------- Generic Mappable API Helper ------------------
import ObjectMapper

extension APIClient {
    
    public func apiMappableRequest<T: Mappable>(params:[String:Any], url:URL, completion: @escaping (_ result:Result<(T,String?), APIRestClient.APIServiceError>) -> Void, activity:Bool? = nil) {
        
        let secondLastPath      = url.deletingLastPathComponent().lastPathComponent
        let requestIdentifier   = "\(secondLastPath)/\(url.lastPathComponent)"
        
        //let timeOut = Constants.API.timeout
        var finalParam          = params
        //        finalParam["userCode"]  = APIClient.userCode
        finalParam["locale"]    = self.clientLocal.toJSON()
        finalParam["package_name"] = "in.woloo.app"
        //finalParam["package_name"] = Bundle.main.bundleIdentifier
        
        let finalParamJson  = finalParam.json()
        //TODO:- Not correct way of checking endpoint for rescue - comment from Ashish
        if requestIdentifier.lowercased() == "//handler.do".lowercased(){
            
            let headers = [APIConstant.requestNameKey:requestIdentifier,APIConstant.contentTypeKey:APIConstant.contentTypeValue,APIConstant.authorization:"Bearer \(UserDefaultsManager.fetchAuthenticationToken())"]
            print("Header Param2:\n \(headers.json())")
            self.restClient.apiDataTask(url: url, method: .post, headers: headers, parameters: params, result: { (result) in
                
                switch result {
                
                case .success(let (response, data)):
                    
                    print("📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍")
                    print("API URL:👉 \(url.absoluteString)")
                    print("API Params:👉 \(finalParam.json())")
                    print("\nAPI Encoded Params:👉 \(params.json())")
                    print("API Mock Response :👉 \(data.json() ?? "")")
                    print("📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍")
                    
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                        DispatchQueue.main.async {
                            completion(.failure(.invalidResponse))
                        }
                        return
                    }
                    
                    if let json = data.json(), let wrapperModel = Mapper<WrapperModel>().map(JSONString: json) {
                        
                        if wrapperModel.code == 200 {
                            var dataJson:String!
                            if let data = wrapperModel.data as? [String:Any] {
                                dataJson = data.json()
                            }
                            else if let data = wrapperModel.data as? [[String:Any]] {
                                dataJson = data.json()
                                
                            }else {
                                dataJson = json
                            }
                            
                            if T.Type.self == WrapperModel.Type.self {
                                DispatchQueue.main.async {
                                    completion(.success((wrapperModel as! T, wrapperModel.message)))
                                }
                                
                            }else if let returnModel:T = Mapper<T>().map(JSONString: dataJson) {
                                DispatchQueue.main.async {
                                    completion(.success((returnModel, wrapperModel.message)))
                                }
                            }else {
                                DispatchQueue.main.async {
                                    completion(.failure(.decodeError))
                                }
                            }
                            
                        }else {
                            DispatchQueue.main.async {
                                completion(.failure(.successWithError(wrapperModel)))
                            }
                        }
                        
                    }else {
                        DispatchQueue.main.async {
                            completion(.failure(.decodeError))
                        }
                    }
                    break
                    
                case .failure(let error):
                    
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        completion(.failure(.apiError))
                    }
                    break
                }
            }).resume()
        }
        else {
            
            self.apiEncodedData(inputJsonString: finalParamJson) { (input, encKey, hmac,token) in
                let encodedParams = ["param1":input,"param2":encKey,"param3":hmac,"locale":self.clientLocal.toJSON()] as [String : Any]
                //TODO:  Need to configure header [Barear:token]
                //                print("📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍")
                //                print("API URL:👉 \(url.absoluteString)")
                //                print("API Params:👉 \(finalParam.json())")
                //                print("API Encoded Params:👉 \(encodedParams.json())")
                //                print("📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍")
                
                let headers = [APIConstant.requestNameKey:requestIdentifier,APIConstant.contentTypeKey:APIConstant.contentTypeValue,APIConstant.authorization:"Bearer \(UserDefaultsManager.fetchAuthenticationToken())"]
                print("Header Param3\n \(headers.json())")
                self.restClient.apiDataTask(url: url, method: .post, headers: headers, parameters: encodedParams, result: { (result) in
                    
                    switch result {
                    
                    case .success(let (response, data)):
                        
                        print("📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍")
                        print("API URL:👉 \(url.absoluteString)")
                        print("API Params:👉 \(finalParam.json())")
                        print("\nAPI Encoded Params:👉 \(encodedParams.json())")
                        print("API Response :👉 \(data.json() ?? "")")
                        print("📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍")
                        
                        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                            DispatchQueue.main.async {
                                completion(.failure(.invalidResponse))
                            }
                            return
                        }
                        
                        if let json = data.json(), let wrapperModel = Mapper<WrapperModel>().map(JSONString: json) {
                             if statusCode == 200 || statusCode == 201 {
                                var dataJson:String!
                                if let data = wrapperModel.data as? [String:Any] {
                                    dataJson = data.json()
                                } else {
                                    dataJson = json
                                }
                                
                                if T.Type.self == WrapperModel.Type.self {
                                    DispatchQueue.main.async {
                                        completion(.success((wrapperModel as! T,wrapperModel.message)))
                                    }
                                } else if let returnModel:T = Mapper<T>().map(JSONString: dataJson) {
                                    DispatchQueue.main.async {
                                        completion(.success((returnModel,wrapperModel.message)))
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        completion(.failure(.decodeError))
                                    }
                                }
                            }
                            else if wrapperModel.code == 200 {
                                var dataJson:String!
                                if let data = wrapperModel.data as? [String:Any] {
                                    dataJson = data.json()
                                }
                                else if let data = wrapperModel.data as? [[String:Any]] {
                                    dataJson = data.json()
                                    
                                } else {
                                    dataJson = json
                                }
                                
                                if T.Type.self == WrapperModel.Type.self {
                                    DispatchQueue.main.async {
                                        completion(.success((wrapperModel as! T,wrapperModel.message)))
                                    }
                                } else if let returnModel:T = Mapper<T>().map(JSONString: dataJson) {
                                    DispatchQueue.main.async {
                                        completion(.success((returnModel,wrapperModel.message)))
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        completion(.failure(.decodeError))
                                    }
                                }
                            } else {
                                DispatchQueue.main.async {
                                    completion(.failure(.successWithError(wrapperModel)))
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                completion(.failure(.decodeError))
                            }
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                        DispatchQueue.main.async {                            completion(.failure(.apiError))
                        }
                        break
                    }
                }).resume()
            }
        }
    }
    
    public func apiMappableUploadRequest<T: Mappable>(params:[String:Any], files:[String:Any]?, url:URL, completion: @escaping (_ result:Result<(T,String?), APIRestClient.APIServiceError>) -> Void) {
        
        
        guard let files = files else  {
            return self.apiMappableRequest(params: params, url: url, completion: completion)
        }
        
        let secondLastPath      = url.deletingLastPathComponent().lastPathComponent
        let requestIdentifier   = "\(secondLastPath)/\(url.lastPathComponent)"
        
        /*
         if url.absoluteString!.contains(API.ipToLocation)  {
         
         }*/
        
        var finalParam          = params
        finalParam["userCode"]  = APIClient.userCode
        finalParam["locale"]    = self.clientLocal.toJSON()
        //finalParam["package_name"] = Bundle.main.bundleIdentifier
        finalParam["package_name"] = "in.woloo.app"
        let finalParamJson      = finalParam.json()
        
        print("finalParamJson: \(finalParamJson)")
        
        self.apiEncodedData(inputJsonString: finalParamJson) { (input, encKey, hmac,token) in
            
            var encodedParams = ["param1":input,"param2":encKey,"param3":hmac] as [String:String]
            let multipartLocal = self.clientLocal.toJSON() as! [String:String]
            for (key, value) in multipartLocal {
                encodedParams["locale[\(key)]"] = value
            }
            
            //TODO:  Need to configure header [Barear:token]
            //            print("📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍")
            //            print("API URL:👉 \(url.absoluteString)")
            //            print("API Params:👉 \(finalParam.json())")
            //            print("API Encoded Params:👉 \(encodedParams.json())")
            //            print("📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍")
            
            let headers = [APIConstant.requestNameKey:requestIdentifier,APIConstant.contentTypeKey:APIConstant.contentTypeMultipartFormDataValue,APIConstant.authorization:"Bearer \(UserDefaultsManager.fetchAuthenticationToken())"]
            print("Header Param4:\n \(headers.json())")
            self.restClient.apiUploadTask(url: url, headers: headers, parameters: encodedParams, files: files, result: { (result) in
                switch result {
                case .success(let (response, data)):
                    print("📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍")
                    print("API URL:👉 \(url.absoluteString)")
                    print("API Params:👉 \(finalParam.json())")
                    print("API Encoded Params:👉 \(encodedParams.json())")
                    print("API Response :👉 \(data.json() ?? "")")
                    print("📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍")
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                        DispatchQueue.main.async {
                            completion(.failure(.invalidResponse))
                        }
                        return
                    }
                    
                    if let json = data.json(), let wrapperModel = Mapper<WrapperModel>().map(JSONString: json) {
                        
                        
                        if statusCode == 200 || statusCode == 201 {
                           var dataJson:String!
                           if let data = wrapperModel.data as? [String:Any] {
                               dataJson = data.json()
                           } else {
                               dataJson = json
                           }
                           
                           if T.Type.self == WrapperModel.Type.self {
                               DispatchQueue.main.async {
                                completion(.success((wrapperModel as! T,wrapperModel.message)))
                               }
                           } else if let returnModel:T = Mapper<T>().map(JSONString: dataJson) {
                               DispatchQueue.main.async {
                                completion(.success((returnModel ,wrapperModel.message)))
                               }
                           } else {
                               DispatchQueue.main.async {
                                   completion(.failure(.decodeError))
                               }
                           }
                       }
                       else if wrapperModel.code == 200 {
                           var dataJson:String!
                           if let data = wrapperModel.data as? [String:Any] {
                               dataJson = data.json()
                           }
                           else if let data = wrapperModel.data as? [[String:Any]] {
                               dataJson = data.json()
                               
                           } else {
                               dataJson = json
                           }
                           
                           if T.Type.self == WrapperModel.Type.self {
                               DispatchQueue.main.async {
                                completion(.success((wrapperModel as! T, wrapperModel.message)))
                               }
                           } else if let returnModel:T = Mapper<T>().map(JSONString: dataJson) {
                               DispatchQueue.main.async {
                                completion(.success((returnModel, wrapperModel.message)))
                               }
                           } else {
                               DispatchQueue.main.async {
                                   completion(.failure(.decodeError))
                               }
                           }
                       } else {
                           DispatchQueue.main.async {
                               completion(.failure(.successWithError(wrapperModel)))
                           }
                       }
                    } else {
                        DispatchQueue.main.async {
                            completion(.failure(.decodeError))
                        }
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        completion(.failure(.apiError))
                    }
                }
            }).resume()
        }
    }
    
    /*
     private func handleResponse<T: Mappable>(result:Result<T, APIRestClient.APIServiceError>, completion: @escaping (Result<T, APIRestClient.APIServiceError>) -> Void) {
     
     }
     */
}



//------------------------------------------------------------------------------------------------
//-------------------------------------- SSL pinning ---------------------------------------------
//------------------------------------------------------------------------------------------------
class URLSessionHandle:NSObject,  URLSessionDelegate {
    
    private static let rsa2048Asn1Header:[UInt8] = [
        0x30, 0x82, 0x01, 0x22, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
        0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0f, 0x00
    ];
    
    var sslKey:String? {
        return APIClient.shared.sslKey
    }
    
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil);
            return;
        }
        //Check if Public Key is available :  We are getting this in auth api response from server, its dynasmic public key returned by server.
        guard let sslKey = self.sslKey else {
            completionHandler(.cancelAuthenticationChallenge, nil);
            return;
        }
        
        // Set SSL policies for domain name check
        let policies = NSMutableArray();
        policies.add(SecPolicyCreateSSL(true, (challenge.protectionSpace.host as CFString)));
        SecTrustSetPolicies(serverTrust, policies);
        
        var isServerTrusted = false
        
        let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0);
        //Compare public key
        let policy = SecPolicyCreateBasicX509();
        let cfCertificates = [certificate] as CFArray;
        
        var trust: SecTrust?
        SecTrustCreateWithCertificates(cfCertificates, policy, &trust);
        
        guard trust != nil, let pubKey = SecTrustCopyPublicKey(trust!) else {
            completionHandler(.cancelAuthenticationChallenge, nil);
            return;
        }
        
        var error:Unmanaged<CFError>?
        if let pubKeyData = SecKeyCopyExternalRepresentation(pubKey, &error) {
            var keyWithHeader = Data(bytes: URLSessionHandle.rsa2048Asn1Header, count: URLSessionHandle.rsa2048Asn1Header.count)
            keyWithHeader.append(pubKeyData as Data);
            
            //Server return public key in hex string, We need to either decoode it or encode (pubKeyData with header) in hexFormate
            //--------------------------------------
            // (keyWithHeader Encode Hex) == sskKey
            // ----------- OR ----------------------
            // (sslKey Decode Hex)  == keyWithHeader
            //---------------------------------------
            let hexKey  = self.hexEncodedString(data: keyWithHeader)
            //let sha256Key = sha256(keyWithHeader);
            if(hexKey == sslKey) {
                isServerTrusted = true;
            }
        } else {
            isServerTrusted = false;
        }
        isServerTrusted = true
        if(isServerTrusted) {
            let credential = URLCredential(trust: serverTrust);
            completionHandler(.useCredential, credential);
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil);
        }
    }
    
    private func hexEncodedString(data:Data) -> String {
        return data.map { String(format: "%02hhx", $0) }.joined()
    }
}

//------------------------------------------------------------------------------------------------


