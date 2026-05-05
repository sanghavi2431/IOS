//
//  TestMore.swift
//  TestMore
//
//  Created by Kapil Dongre on 30/12/24.
//

import XCTest
@testable import Woloo

final class TestMore: XCTestCase {
    
    var buySubscriptionVC: BuySubscriptionVC!
    var historyVC: HistoryVC!
    var myOfferVC: MyOfferVC!
    var addGiftCard: AddGiftCardVC!
    var becomeHostFormVC: BecomeHostFormVC!
    //MARK: - Buy subscription VC
    
    func test_buy_subscription_response(){
        
        let storyboard = UIStoryboard(name: "Subscription", bundle: nil)
        buySubscriptionVC = storyboard.instantiateViewController(withIdentifier: "BuySubscriptionVC") as? BuySubscriptionVC
        
        let expectation = self.expectation(description: "Buy_Subscription_RESPONSE")
        
        guard let wolooToken = ProcessInfo.processInfo.environment["WOLOO_TOKEN"] else {
            XCTFail("WOLOO_TOKEN is not set")
            return
        }
        
        let headers = ["x-woloo-token": wolooToken,"user-agent": "IOS"]
        
        NetworkManager(headers: headers, url: nil, service: .mySubscription, method: .get, isJSONRequest: false).executeQuery { (result: Result<BaseResponse<MySubscriptionModel>, Error>) in
            switch result {
                
            case.success(let response):
                print("My subscription Response ", response)
                XCTAssertNotNil(response.results)
                expectation.fulfill()
                
            case .failure(let error):
                print("My subscription Error response ", error)
                XCTFail("Nearby API call failed with error: \(error.localizedDescription)")
                expectation.fulfill()
                
            }
        }
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    
    //MARK: - MyHistory Module
    func test_my_history_API_Response(){
        let storyboard = UIStoryboard(name: "More", bundle: nil)
        historyVC = storyboard.instantiateViewController(withIdentifier: "HistoryVC") as? HistoryVC
        
        let expectation = self.expectation(description: "My_History_RESPONSE")
        
        let data = ["pageNumber": 0]
        
        guard let wolooToken = ProcessInfo.processInfo.environment["WOLOO_TOKEN"] else {
            XCTFail("WOLOO_TOKEN is not set")
            return
        }
        
        let headers = ["x-woloo-token": wolooToken,"user-agent": "IOS"]
        
        NetworkManager(data: data, headers: headers, url: nil, service: .wolooRewardHistory, method: .get, isJSONRequest: false).executeQuery { (result: Result<BaseResponse<MyHistory>, Error>) in
            switch result {
            case.success(let response):
                print("My history Response ", response)
                XCTAssertNotNil(response.results)
                expectation.fulfill()
                
            case .failure(let error):
                print("My History Error response ", error)
                XCTFail("My History API call failed with error: \(error.localizedDescription)")
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    //MARK: - My Offers
    func test_My_Offer_response(){
        
        let storyboard = UIStoryboard(name: "More", bundle: nil)
        myOfferVC = storyboard.instantiateViewController(withIdentifier: "MyOfferVC") as? MyOfferVC
        
        let expectation = self.expectation(description: "My_Offer_RESPONSE")
        
        guard let wolooToken = ProcessInfo.processInfo.environment["WOLOO_TOKEN"] else {
            XCTFail("WOLOO_TOKEN is not set")
            return
        }
        
        let headers = ["x-woloo-token": wolooToken,"user-agent": "IOS"]
        
        NetworkManager(headers: headers, url: nil, service: .mySubscription, method: .get, isJSONRequest: false).executeQuery { (result: Result<BaseResponse<MySubscriptionModel>, Error>) in
            switch result {
                
            case.success(let response):
                print("My offer Response ", response)
                XCTAssertNotNil(response.results)
                expectation.fulfill()
                
            case .failure(let error):
                print("My offer Error response ", error)
                XCTFail("My offer API call failed with error: \(error.localizedDescription)")
                expectation.fulfill()
                
            }
        }
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    //MARK: - Woloo Gift card
    
    func test_Add_Coins_API_Response(){
        
        let storyboard = UIStoryboard(name: "More", bundle: nil)
        addGiftCard = storyboard.instantiateViewController(withIdentifier: "AddGiftCardVC") as? AddGiftCardVC
        
        let expectation = self.expectation(description: "Add_Coins_RESPONSE")
        
        guard let wolooToken = ProcessInfo.processInfo.environment["WOLOO_TOKEN"] else {
            XCTFail("WOLOO_TOKEN is not set")
            return
        }
        
        let headers = ["x-woloo-token": wolooToken,"user-agent": "IOS"]
        
        let data = ["mobile": "7840903848", "coins": 50, "message": "Hello Sending Gifts"] as [String : Any]
        
        NetworkManager(data: data, headers: headers, url: nil, service: .addCoins, method: .post, isJSONRequest: true).executeQuery { (result: Result<BaseResponse<AddCoinsModel>, Error>) in
            switch result{
            case .success(let response):
                print("Add coins response: ", response)
                XCTAssertNotNil(response.results)
                expectation.fulfill()
                
            case .failure(let error):
                print("Add coins error: ", error)
                XCTFail("Add coins API call failed with error: \(error.localizedDescription)")
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_Add_Woloo_API_Success() {
        
        let storyboard = UIStoryboard(name: "More", bundle: nil)
        becomeHostFormVC = storyboard.instantiateViewController(withIdentifier: "BecomeHostFormVC") as? BecomeHostFormVC
        
        let expectation = self.expectation(description: "Add_Woloo_API_Response")
        
        guard let wolooToken = ProcessInfo.processInfo.environment["WOLOO_TOKEN"] else {
            XCTFail("WOLOO_TOKEN is not set")
            return
        }
        
        guard let add_woloo_name = ProcessInfo.processInfo.environment["add_woloo_name"] else {
            XCTFail("add_woloo_name is not set")
            return
        }
        guard let add_woloo_city = ProcessInfo.processInfo.environment["add_woloo_city"] else {
            XCTFail("add_woloo_city is not set")
            return
        }
        guard let add_woloo_pin = ProcessInfo.processInfo.environment["add_woloo_pin"] else {
            XCTFail("add_woloo_pin is not set")
            return
        }
        guard let add_woloo_address = ProcessInfo.processInfo.environment["add_woloo_address"] else {
            XCTFail("add_woloo_address is not set")
            return
        }
        
        guard let latitude = ProcessInfo.processInfo.environment["lat_Sucess"] else {
            XCTFail("latitude is not set")
            return
        }
        
        guard let longitude = ProcessInfo.processInfo.environment["long_Success"] else {
            XCTFail("longitude is not set")
            return
        }
        
        let headers = ["x-woloo-token": wolooToken, "user-agent": "IOS"]
        
        let parameters = NSMutableDictionary()
        parameters.setValue(add_woloo_name, forKey: "name")
        parameters.setValue(add_woloo_address, forKey: "address")
        parameters.setValue(add_woloo_city, forKey: "city")
        parameters.setValue(latitude, forKey: "lat")
        parameters.setValue(longitude, forKey: "lng")
        parameters.setValue(add_woloo_pin, forKey: "pincode")
        let images: [UIImage] = loadImagesFromResources()  // Imp
        let api = WolooHostRouterAPI(params: parameters)
        
        api.POSTAction(action: .addWoloo, endValue: "") { multipartFormData in
            // Append each image from the array
            for (index, image) in images.enumerated() {
                let imgData = Utility.compressImage(image: image)
                let fileName = "image_\(index).jpeg"
                multipartFormData.append(imgData, withName: "image", fileName: fileName, mimeType: "image/jpeg")
            }
        } completion: { (response) in
            if SSError.isErrorReponse(operation: response.response) {
                let error = SSError.errorWithData(data: response)
                print("Error response:", error.localizedDescription)
                XCTFail("Add Woloo API call failed with error: \(error.localizedDescription)")
                expectation.fulfill()
            } else {
                guard let data = response.data else {
                    XCTFail("No data received in response")
                    expectation.fulfill()
                    return
                }
                if let objParsed: BaseResponse<StatusSuccessResponseModel> = BaseResponse<StatusSuccessResponseModel>.decode(data) {
                    print("Add Woloo API Response:", objParsed)
                    XCTAssertNotNil(objParsed.results)
                    expectation.fulfill()
                } else {
                    XCTFail("Failed to parse response data")
                    expectation.fulfill()
                }
            }
        }
        
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_Add_Woloo_API_failure(){
        
        let storyboard = UIStoryboard(name: "More", bundle: nil)
        becomeHostFormVC = storyboard.instantiateViewController(withIdentifier: "BecomeHostFormVC") as? BecomeHostFormVC
        
        let expectation = self.expectation(description: "Add_Woloo_API_Response")
        
        guard let wolooToken = ProcessInfo.processInfo.environment["WOLOO_TOKEN"] else {
            XCTFail("WOLOO_TOKEN is not set")
            return
        }
        
        guard let add_woloo_name = ProcessInfo.processInfo.environment["add_woloo_name"] else {
            XCTFail("add_woloo_name is not set")
            return
        }
        guard let add_woloo_city = ProcessInfo.processInfo.environment["add_woloo_city"] else {
            XCTFail("add_woloo_city is not set")
            return
        }
        guard let add_woloo_pin = ProcessInfo.processInfo.environment["add_woloo_pin"] else {
            XCTFail("add_woloo_pin is not set")
            return
        }
        guard let add_woloo_address = ProcessInfo.processInfo.environment["add_woloo_address"] else {
            XCTFail("add_woloo_address is not set")
            return
        }
        
        guard let latitude = ProcessInfo.processInfo.environment["lat_Sucess"] else {
            XCTFail("latitude is not set")
            return
        }
        
        guard let longitude = ProcessInfo.processInfo.environment["long_Success"] else {
            XCTFail("longitude is not set")
            return
        }
        
        let headers = ["x-woloo-token": wolooToken, "user-agent": "IOS"]
        
        let parameters = NSMutableDictionary()
        parameters.setValue(add_woloo_name, forKey: "name")
        parameters.setValue(add_woloo_address, forKey: "address")
        parameters.setValue(add_woloo_city, forKey: "city")
        parameters.setValue(latitude, forKey: "lat")
        parameters.setValue(longitude, forKey: "lng")
        parameters.setValue(add_woloo_pin, forKey: "pincode")
        let images: [UIImage] = loadImagesFromResources()  // Imp
        let api = WolooHostRouterAPI(params: parameters)
        
        api.POSTAction(action: .addWoloo, endValue: "") { multipartFormData in
            // Append each image from the array
            for (index, image) in images.enumerated() {
                let imgData = Utility.compressImage(image: image)
                let fileName = "image_\(index).jpeg"
                multipartFormData.append(imgData, withName: "image", fileName: fileName, mimeType: "image/jpeg")
            }
        } completion: { (response) in
            if SSError.isErrorReponse(operation: response.response) {
                let error = SSError.errorWithData(data: response)
                print("Error response:", error.localizedDescription)
                XCTFail("Add Woloo API call failed with error: \(error.localizedDescription)")
                expectation.fulfill()
            } else {
                guard let data = response.data else {
                    XCTFail("No data received in response")
                    expectation.fulfill()
                    return
                }
                if let objParsed: BaseResponse<StatusSuccessResponseModel> = BaseResponse<StatusSuccessResponseModel>.decode(data) {
                    print("Add Woloo API Response:", objParsed)
                    
                    if let data = response.data, let parsedResponse: BaseResponse<StatusSuccessResponseModel> = BaseResponse<StatusSuccessResponseModel>.decode(data) {
                        if let message = parsedResponse.results.message, message == "Email id is already associated with another woloo!" {
                            XCTFail("The email ID is already associated with another Woloo!")
                        }else {
                            XCTFail("Failed to parse response data")
                        }
                        XCTAssertNotNil(objParsed.results)
                        expectation.fulfill()
                    } else {
                        XCTFail("Failed to parse response data")
                        expectation.fulfill()
                    }
                }
            }
            
            self.waitForExpectations(timeout: 5, handler: nil)
            
            
        }
    }
    
    func recommend_Woloo_API_Success(){
        
        let storyboard = UIStoryboard(name: "More", bundle: nil)
        becomeHostFormVC = storyboard.instantiateViewController(withIdentifier: "BecomeHostFormVC") as? BecomeHostFormVC
        
        let expectation = self.expectation(description: "Add_Woloo_API_Response")
        
        guard let wolooToken = ProcessInfo.processInfo.environment["WOLOO_TOKEN"] else {
            XCTFail("WOLOO_TOKEN is not set")
            return
        }
        
        guard let add_woloo_name = ProcessInfo.processInfo.environment["add_woloo_name"] else {
            XCTFail("add_woloo_name is not set")
            return
        }
        guard let add_woloo_city = ProcessInfo.processInfo.environment["add_woloo_city"] else {
            XCTFail("add_woloo_city is not set")
            return
        }
        guard let add_woloo_pin = ProcessInfo.processInfo.environment["add_woloo_pin"] else {
            XCTFail("add_woloo_pin is not set")
            return
        }
        guard let add_woloo_address = ProcessInfo.processInfo.environment["add_woloo_address"] else {
            XCTFail("add_woloo_address is not set")
            return
        }
        
        guard let latitude = ProcessInfo.processInfo.environment["lat_Sucess"] else {
            XCTFail("latitude is not set")
            return
        }
        
        guard let longitude = ProcessInfo.processInfo.environment["long_Success"] else {
            XCTFail("longitude is not set")
            return
        }
        
        let headers = ["x-woloo-token": wolooToken, "user-agent": "IOS"]
        
        let parameters = NSMutableDictionary()
        parameters.setValue(add_woloo_name, forKey: "name")
        parameters.setValue(add_woloo_address, forKey: "address")
        parameters.setValue(add_woloo_city, forKey: "city")
        parameters.setValue(latitude, forKey: "lat")
        parameters.setValue(longitude, forKey: "lng")
        parameters.setValue(add_woloo_pin, forKey: "pincode")
        let images: [UIImage] = loadImagesFromResources()  // Imp
        let api = WolooHostRouterAPI(params: parameters)
        
        api.POSTAction(action: .recommendWoloo, endValue: "") { multipartFormData in
            // Append each image from the array
            for (index, image) in images.enumerated() {
                let imgData = Utility.compressImage(image: image)
                let fileName = "image_\(index).jpeg"
                multipartFormData.append(imgData, withName: "image", fileName: fileName, mimeType: "image/jpeg")
            }
        } completion: { (response) in
            if SSError.isErrorReponse(operation: response.response) {
                let error = SSError.errorWithData(data: response)
                print("Error response:", error.localizedDescription)
                XCTFail("Add Woloo API call failed with error: \(error.localizedDescription)")
                expectation.fulfill()
            } else {
                guard let data = response.data else {
                    XCTFail("No data received in response")
                    expectation.fulfill()
                    return
                }
                if let objParsed: BaseResponse<StatusSuccessResponseModel> = BaseResponse<StatusSuccessResponseModel>.decode(data) {
                    print("Add Woloo API Response:", objParsed)
                    XCTAssertNotNil(objParsed.results)
                    expectation.fulfill()
                } else {
                    XCTFail("Failed to parse response data")
                    expectation.fulfill()
                }
            }
        }
        
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    func recommend_Woloo_API_Failure(){
        let storyboard = UIStoryboard(name: "More", bundle: nil)
        becomeHostFormVC = storyboard.instantiateViewController(withIdentifier: "BecomeHostFormVC") as? BecomeHostFormVC
        
        let expectation = self.expectation(description: "recommend_Woloo_Response")
        
        guard let wolooToken = ProcessInfo.processInfo.environment["WOLOO_TOKEN"] else {
            XCTFail("WOLOO_TOKEN is not set")
            return
        }
        
        guard let add_woloo_name = ProcessInfo.processInfo.environment["add_woloo_name"] else {
            XCTFail("add_woloo_name is not set")
            return
        }
        guard let add_woloo_city = ProcessInfo.processInfo.environment["add_woloo_city"] else {
            XCTFail("add_woloo_city is not set")
            return
        }
        guard let add_woloo_pin = ProcessInfo.processInfo.environment["add_woloo_pin"] else {
            XCTFail("add_woloo_pin is not set")
            return
        }
        guard let add_woloo_address = ProcessInfo.processInfo.environment["add_woloo_address"] else {
            XCTFail("add_woloo_address is not set")
            return
        }
        
        guard let latitude = ProcessInfo.processInfo.environment["lat_Sucess"] else {
            XCTFail("latitude is not set")
            return
        }
        
        guard let longitude = ProcessInfo.processInfo.environment["long_Success"] else {
            XCTFail("longitude is not set")
            return
            
        }
        
        guard let mobNumber = ProcessInfo.processInfo.environment["mob_number"] else {
               XCTFail("Mobile number is not set")
               return
           }
        
        let headers = ["x-woloo-token": wolooToken, "user-agent": "IOS"]
        
        let parameters = NSMutableDictionary()
        parameters.setValue(add_woloo_name, forKey: "name")
        parameters.setValue(add_woloo_address, forKey: "address")
        parameters.setValue(add_woloo_city, forKey: "city")
        parameters.setValue(latitude, forKey: "lat")
        parameters.setValue(longitude, forKey: "lng")
        parameters.setValue(add_woloo_pin, forKey: "pincode")
        parameters.setValue(mobNumber, forKey: "recommended_mobile")
        let images: [UIImage] = loadImagesFromResources()  // Imp
        let api = WolooHostRouterAPI(params: parameters)
        
        api.POSTAction(action: .recommendWoloo, endValue: "") { multipartFormData in
            // Append each image from the array
            for (index, image) in images.enumerated() {
                let imgData = Utility.compressImage(image: image)
                let fileName = "image_\(index).jpeg"
                multipartFormData.append(imgData, withName: "image", fileName: fileName, mimeType: "image/jpeg")
            }
        } completion: { (response) in
            if SSError.isErrorReponse(operation: response.response) {
                let error = SSError.errorWithData(data: response)
                print("Error response:", error.localizedDescription)
                XCTFail("recommend_Woloo API call failed with error: \(error.localizedDescription)")
                expectation.fulfill()
            } else {
                guard let data = response.data else {
                    XCTFail("No data received in response")
                    expectation.fulfill()
                    return
                }
                if let objParsed: BaseResponse<StatusSuccessResponseModel> = BaseResponse<StatusSuccessResponseModel>.decode(data) {
                    print("recommend_Woloo API Response:", objParsed)
                    
                    if let data = response.data, let parsedResponse: BaseResponse<StatusSuccessResponseModel> = BaseResponse<StatusSuccessResponseModel>.decode(data) {
                        if let message = parsedResponse.results.message, message == "Email id is already associated with another woloo!" {
                            XCTFail("The email ID is already associated with another Woloo!")
                        }else {
                            XCTFail("Failed to parse response data")
                        }
                        XCTAssertNotNil(objParsed.results)
                        expectation.fulfill()
                    } else {
                        XCTFail("Failed to parse response data")
                        expectation.fulfill()
                    }
                }
            }
            
            self.waitForExpectations(timeout: 5, handler: nil)
            
            
        }
    }
    
    //MARK: - loadImagesFromResources
    func loadImagesFromResources() -> [UIImage] {
        var images: [UIImage] = []
        
        // You can add images from the app's bundle (Asset Catalog or Resources folder)
        if let image1 = UIImage(named: "cibil_img_poor.png") {
            images.append(image1)
        }
        if let image2 = UIImage(named: "cibil_img_very_good.png") {
            images.append(image2)
        }
        // Add more images as needed
        
        return images
    }
}
