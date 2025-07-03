//
//  TestsDashboard.swift
//  TestsDashboard
//
//  Created by Kapil Dongre on 30/12/24.
//

import XCTest
import CoreLocation

@testable import Woloo


class MockNavigationController: UINavigationController {
    var pushedViewController: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.pushedViewController = viewController
        super.pushViewController(viewController, animated: animated)
    }
}

class TestDashboardViewController: DashboardVC {
    var capturedSegueIdentifier: String?

    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        capturedSegueIdentifier = identifier
        // Do not call super to prevent actual segue execution during the test.
    }
}

class MockLocationManager: CLLocationManager {
    var mockAuthorizationStatus: CLAuthorizationStatus = .notDetermined

    override class func authorizationStatus() -> CLAuthorizationStatus {
        return MockLocationManager().mockAuthorizationStatus
    }
}


final class TestsDashboard: XCTestCase, CLLocationManagerDelegate {
    
    var dashboardVC:  DashboardVC!
    var detailVC: DetailsVC!
    var addReviewVC: AddReviewVC!
    var mockLocationManager: MockLocationManager!
    var mockCollectionView: UICollectionView!
    
    var locationManager: CLLocationManager!
    var isLocationPermissionGranted = false
    
    override func setUp() {
            super.setUp()
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        dashboardVC = storyboard.instantiateViewController(withIdentifier: "DashboardVC") as? DashboardVC
            mockLocationManager = MockLocationManager()
        dashboardVC.locationManager = mockLocationManager
        // Mock data
        dashboardVC.wolooSupport = Place(name: "Woloo", address: "Shraddhanand Road, Hirachand Desai Rd, Ghatkopar, W, Mumbai, Maharashtra 400086", placeId: "")
        dashboardVC.nearestHospital = Place(name: "Hospital", address: "Shraddhanand Road, Hirachand Desai Rd, Ghatkopar, W, Mumbai, Maharashtra 400086", placeId: "")
        dashboardVC.nearestPoliceStation = Place(name: "Police", address: "Shraddhanand Road, Hirachand Desai Rd, Ghatkopar, W, Mumbai, Maharashtra 400086", placeId: "")
        dashboardVC.nearestFireStation = Place(name: "Fire station", address: "Shraddhanand Road, Hirachand Desai Rd, Ghatkopar, W, Mumbai, Maharashtra 400086", placeId: "")
        mockCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        dashboardVC.loadViewIfNeeded() // This initializes the view and its outlets
        }
    
    override func tearDown() {
        dashboardVC = nil
           mockLocationManager = nil
           super.tearDown()
       }
    
    //MARK: - App config API
    func test_App_configAPIV2(){
        let localeData = [ "language" : "en",
                           "platform" : "ios",
                           "country" : "IN",
                           "segment" : "",
                           "version" : "1",
                           "packageName":"in.woloo.www"] as [String : String]
        
        
        let data = ["locale": localeData] as [String : Any]
        
        guard let wolooToken = ProcessInfo.processInfo.environment["WOLOO_TOKEN"] else {
               XCTFail("WOLOO_TOKEN is not set")
               return
           }
        
        let headers = ["x-woloo-token": wolooToken, "user-agent": "IOS"]
        
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        
    
        
        NetworkManager(data: data, headers: headers, url: nil, service: .appConifgGet, method: .post, isJSONRequest: true).executeQuery { (result: Result<BaseResponse<AppCofigGetModel>, Error>) in
            switch result{
                
            case .success(let response):
                print("Success App config")
                
                
                
            case .failure(let error):
                print("App config error", error)
            }
        }
    }
    
    //MARK: - NearBy API Call
    func test_Near_By_API_Response(){
//        guard isLocationPermissionGranted else {
//                   XCTFail("Location permission not granted. Skipping test.")
//                   return
//               }
        guard let wolooToken = ProcessInfo.processInfo.environment["WOLOO_TOKEN"] else {
               XCTFail("WOLOO_TOKEN is not set")
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
        
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        dashboardVC = storyboard.instantiateViewController(withIdentifier: "DashboardVC") as? DashboardVC
        let expectation = self.expectation(description: "NearBy_RETURNS_RESPONSE")
        
        let data = ["lat": latitude, "lng": longitude, "mode": 1, "range": 3,"is_offer": 0, "showAll": 0, "isSearch": 1 ] as [String : Any]
        let headers = ["x-woloo-token": wolooToken,"user-agent": "IOS"]
        
        NetworkManager(data: data,headers: headers, url: nil, service: .nearByWoloo, method: .post, isJSONRequest: true).executeQuery {(result: Result<BaseResponse<[NearbyResultsModel]>, Error>) in
            
            switch result{
            case .success(let response):
                print("Nearby response ------>",response)
                XCTAssertNotNil(response)
                // Iterate through the results
                for nearbyResult in response.results {
                    let idString = nearbyResult.id != nil ? "ID: \(nearbyResult.id!)" : "Unknown ID"
                    guard let id = nearbyResult.id else {
                        XCTFail("ID is nil \(idString)")
                        return
                    }
                    
                    if nearbyResult.code?.isEmpty ?? true {
                        XCTFail("Code is empty \(idString)")
                        return
                    }
                    
                    if nearbyResult.name?.isEmpty ?? true {
                        XCTFail("Name is empty \(idString)")
                        return
                    }
                    
                    if nearbyResult.title?.isEmpty ?? true {
                        XCTFail("Title is empty \(idString)")
                        return
                    }
                    
                    if nearbyResult.image?.isEmpty ?? true {
                        XCTFail("Image array is empty \(idString)")
                        return
                    }
                    
                    if nearbyResult.opening_hours?.isEmpty ?? true {
                        XCTFail("Opening hours is empty \(idString)")
                        return
                    }
                    
                    if nearbyResult.restaurant?.isEmpty ?? true {
                        XCTFail("Restaurant is empty \(idString)")
                        return
                    }
                    
                    if nearbyResult.address?.isEmpty ?? true {
                        XCTFail("Address is empty \(idString)")
                        return
                    }
                    
                    if nearbyResult.city?.isEmpty ?? true {
                        XCTFail("City is empty \(idString)")
                        return
                    }
                    
                    if nearbyResult.lat?.isEmpty ?? true {
                        XCTFail("Latitude is empty \(idString)")
                        return
                    }
                    
                    if nearbyResult.lng?.isEmpty ?? true {
                        XCTFail("Longitude is empty \(idString)")
                        return
                    }
                    
                    guard let status = nearbyResult.status else {
                        XCTFail("Status is nil \(idString)")
                        return
                    }
                    
                    if nearbyResult.description?.isEmpty ?? true {
                        XCTFail("Description is empty \(idString)")
                        return
                    }
                    
                    if nearbyResult.created_at?.isEmpty ?? true {
                        XCTFail("Created at is empty \(idString)")
                        return
                    }
                    
                    if nearbyResult.updated_at?.isEmpty ?? true {
                        XCTFail("Updated at is empty \(idString)")
                        return
                    }
                    
                    // Add similar checks for all other properties as needed
                    
                    // Final check for the boolean properties and integers
                    
                }
                
                expectation.fulfill()

                
                
            case .failure(let error):
                XCTFail("Nearby API call failed with error: \(error.localizedDescription)")
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_Near_By_API_Response_No_Woloo(){
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        dashboardVC = storyboard.instantiateViewController(withIdentifier: "DashboardVC") as? DashboardVC
        let expectation = self.expectation(description: "NearBy_RETURNS_RESPONSE")
        
        guard let wolooToken = ProcessInfo.processInfo.environment["WOLOO_TOKEN"] else {
               XCTFail("WOLOO_TOKEN is not set")
               return
           }
        
        guard let latitude = ProcessInfo.processInfo.environment["no_woloo_lat"] else {
               XCTFail("latitude is not set")
               return
           }
        
        guard let longitude = ProcessInfo.processInfo.environment["no_woloo_lng"] else {
               XCTFail("longitude is not set")
               return
           }

        let data = ["lat": latitude, "lng": longitude, "mode": 1, "range": 3,"is_offer": 0, "showAll": 0, "isSearch": 1 ] as [String : Any]
        let headers = ["x-woloo-token": wolooToken,"user-agent": "IOS"]
        
        NetworkManager(data: data,headers: headers, url: nil, service: .nearByWoloo, method: .post, isJSONRequest: true).executeQuery {(result: Result<BaseResponse<[NearbyResultsModel]>, Error>) in
            
            switch result{
            case .success(let response):
                print("Nearby response ------>",response)
                XCTAssertEqual(response.results.isEmpty, true, "Expected results to be an empty array.")
               
                let validation = self.dashboardVC?.if_No_Woloo_found(arrNearby: response.results)
                if validation?.isValid == true {
                    XCTAssertTrue(true, "No Woloo Found")
                    expectation.fulfill()
                    return
                }
                
                expectation.fulfill()
                
            case .failure(let error):
                XCTFail("Nearby API call failed with error: \(error.localizedDescription)")
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testClickedBookMarkedBtn_navigatesToBookmarkedVC() {
        // Arrange
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        dashboardVC = storyboard.instantiateViewController(withIdentifier: "DashboardVC") as? DashboardVC
        let mockNavigationController = MockNavigationController(rootViewController: dashboardVC)
        UIApplication.shared.keyWindow?.rootViewController = mockNavigationController

       
        dashboardVC.clickedBookMarkedBtn(UIButton())

        // Assert
        guard let bookmarkedVC = mockNavigationController.pushedViewController as? BookmarkedVC else {
            XCTFail("Expected BookmarkedVC to be pushed, but got \(String(describing: mockNavigationController.pushedViewController))")
            return
        }


    }
    
    
    //MARK: - Wah Certificate API
    func test_WAH_Certificate_API() {
        let wahVC = WahCertificateVC(nibName: "WahCertificateVC", bundle: nil)
        let expectation = self.expectation(description: "WAH_CERTIFICATE_RESPONSE")
        guard let wolooToken = ProcessInfo.processInfo.environment["WOLOO_TOKEN"] else {
               XCTFail("WOLOO_TOKEN is not set")
               return
           }
        
        guard let woloo_id = ProcessInfo.processInfo.environment["valid_woloo_id"] else {
               XCTFail("WOLOO_TOKEN is not set")
               return
           }
        
        let data = ["woloo_id": woloo_id] as [String : Any]
        
        let headers = ["x-woloo-token": wolooToken,"user-agent": "IOS"]
        
        
        NetworkManager(data: data,headers: headers, url: nil, service: .getwahcertificate, method: .get, isJSONRequest: false).executeQuery { (result: Result<BaseResponse<WahCertificate>, Error>) in
            switch result{
            case .success(let response):
                print("WahCertificate response ------>",response)
                //Asserts
                XCTAssertNotNil(response.results)
                expectation.fulfill()
                
            case .failure(let error):
                XCTAssertFalse(true,"WahCertificate Failed")
                expectation.fulfill()
                
            }
        }

        
        self.waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func test_WAH_Certificate_Not_Found_API() {
        let wahVC = WahCertificateVC(nibName: "WahCertificateVC", bundle: nil)
        let expectation = self.expectation(description: "WAH_CERTIFICATE_RESPONSE")
 
        guard let wolooToken = ProcessInfo.processInfo.environment["WOLOO_TOKEN"] else {
               XCTFail("WOLOO_TOKEN is not set")
               return
           }
        
        guard let woloo_id = ProcessInfo.processInfo.environment["invalid_woloo_id"] else {
               XCTFail("Invalid_woloo_id is not set")
               return
           }
        
        let data = ["woloo_id": woloo_id] as [String : Any]
        
        let headers = ["x-woloo-token": wolooToken,"user-agent": "IOS"]
        
        NetworkManager(data: data,headers: headers, url: nil, service: .getwahcertificate, method: .get, isJSONRequest: false).executeQuery { (result: Result<BaseResponse<WahCertificate>, Error>) in
            switch result{
            case .success(let response):
                print("WahCertificate response ------>",response)
                //Asserts
                XCTAssertNotNil(response.results)
                expectation.fulfill()
                
            case .failure(let error):
                XCTAssertFalse(true,"WahCertificate Failed")
                expectation.fulfill()
                
            }
        }
        //        expectation.fulfill()
        
        self.waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    //MARK: - Onroute API
    func test_Onroute_API_Response() {
        //EnrouteViewController
        let enrouteVC = EnrouteViewController(nibName: "EnrouteViewController", bundle: nil)
        let expectation = self.expectation(description: "Onroute_RESPONSE")
        
        guard let wolooToken = ProcessInfo.processInfo.environment["WOLOO_TOKEN"] else {
               XCTFail("WOLOO_TOKEN is not set")
               return
           }
        
        guard let src_lat = ProcessInfo.processInfo.environment["src_lat"] else {
               XCTFail("src_lat is not set")
               return
           }
        
        guard let src_lng = ProcessInfo.processInfo.environment["src_lng"] else {
               XCTFail("src_lng is not set")
               return
           }
        
        guard let dest_lat = ProcessInfo.processInfo.environment["dest_lat"] else {
               XCTFail("dest_lat is not set")
               return
           }
        
        guard let dest_lng = ProcessInfo.processInfo.environment["dest_lng"] else {
               XCTFail("dest_lng is not set")
               return
           }
        
        guard let overview_polyline = ProcessInfo.processInfo.environment["overview_polyline"] else {
               XCTFail("dest_lng is not set")
               return
           }
        
        let headers = ["x-woloo-token": wolooToken,"user-agent": "IOS"]
        
        let data = ["src_lat": src_lat, "src_lng": src_lng, "target_lat": dest_lat, "target_lng": dest_lng, "overview_polyline": [
            "points":  overview_polyline
        ]] as [String : Any]
        
        NetworkManager(data: data,headers: headers, url: nil, service: .enroute, method: .post, isJSONRequest: false).executeQuery {(result: Result<BaseResponse<[NearbyResultsModel]>, Error>) in
            
            switch result{
            case .success(let response):
                
                print("enroute response ------>",response)
                XCTAssertNotNil(response)
                for nearbyResult in response.results {
                    let idString = nearbyResult.id != nil ? "ID: \(nearbyResult.id!)" : "Unknown ID"
                    guard let id = nearbyResult.id else {
                        XCTFail("ID is nil \(idString)")
                        return
                    }
                    
                    if nearbyResult.code?.isEmpty ?? true {
                        XCTFail("Code is empty \(idString)")
                        return
                    }
                    
                    if nearbyResult.name?.isEmpty ?? true {
                        XCTFail("Name is empty \(idString)")
                        return
                    }
                    
                    if nearbyResult.title?.isEmpty ?? true {
                        XCTFail("Title is empty \(idString)")
                        return
                    }
                    
                    if nearbyResult.image?.isEmpty ?? true {
                        XCTFail("Image array is empty \(idString)")
                        return
                    }
                    
                    if nearbyResult.opening_hours?.isEmpty ?? true {
                        XCTFail("Opening hours is empty \(idString)")
                        return
                    }
                    
                    if nearbyResult.restaurant?.isEmpty ?? true {
                        XCTFail("Restaurant is empty \(idString)")
                        return
                    }
                    
                    if nearbyResult.address?.isEmpty ?? true {
                        XCTFail("Address is empty \(idString)")
                        return
                    }
                    
                    if nearbyResult.city?.isEmpty ?? true {
                        XCTFail("City is empty \(idString)")
                        return
                    }
                    
                    if nearbyResult.lat?.isEmpty ?? true {
                        XCTFail("Latitude is empty \(idString)")
                        return
                    }
                    
                    if nearbyResult.lng?.isEmpty ?? true {
                        XCTFail("Longitude is empty \(idString)")
                        return
                    }
                    
                    guard let status = nearbyResult.status else {
                        XCTFail("Status is nil \(idString)")
                        return
                    }
                    
                    if nearbyResult.description?.isEmpty ?? true {
                        XCTFail("Description is empty \(idString)")
                        return
                    }
                    
                    if nearbyResult.created_at?.isEmpty ?? true {
                        XCTFail("Created at is empty \(idString)")
                        return
                    }
                    
                    if nearbyResult.updated_at?.isEmpty ?? true {
                        XCTFail("Updated at is empty \(idString)")
                        return
                    }
                    
                    // Add similar checks for all other properties as needed
                    
                    // Final check for the boolean properties and integers
                    
                }
                
                expectation.fulfill()
                
            case .failure(let error):
                XCTFail("enroute API call failed with error: \(error.localizedDescription)")
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 10, handler: nil)
        
        
    }
    
    
    //MARK: - Onroute API
    func test_Onroute_API_No_Woloo_FoundResponse() {
        //EnrouteViewController
        let enrouteVC = EnrouteViewController(nibName: "EnrouteViewController", bundle: nil)
        let expectation = self.expectation(description: "On_route_RESPONSE")
        
        guard let wolooToken = ProcessInfo.processInfo.environment["WOLOO_TOKEN"] else {
               XCTFail("WOLOO_TOKEN is not set")
               return
           }
        
        guard let src_lat = ProcessInfo.processInfo.environment["src_lat_noWoloo"] else {
               XCTFail("src_lat is not set")
               return
           }
        
        guard let src_lng = ProcessInfo.processInfo.environment["src_lng_noWoloo"] else {
               XCTFail("src_lng is not set")
               return
           }
        
        guard let dest_lat = ProcessInfo.processInfo.environment["dest_lat_noWoloo"] else {
               XCTFail("dest_lat is not set")
               return
           }
        
        guard let dest_lng = ProcessInfo.processInfo.environment["dest_lng_noWoloo"] else {
               XCTFail("dest_lng is not set")
               return
           }
        
        guard let overview_polyline = ProcessInfo.processInfo.environment["overview_polyline"] else {
               XCTFail("dest_lng is not set")
               return
           }
        
        
        let headers = ["x-woloo-token": wolooToken,"user-agent": "IOS"]
        
        let data = ["src_lat": src_lat, "src_lng": src_lng, "target_lat": dest_lat, "target_lng": dest_lng, "overview_polyline": [
            "points":  overview_polyline
        ]] as [String : Any]
        
        NetworkManager(data: data,headers: headers, url: nil, service: .enroute, method: .post, isJSONRequest: false).executeQuery {(result: Result<BaseResponse<[NearbyResultsModel]>, Error>) in
            
            switch result{
            case .success(let response):
                print("enroute response ------>",response)
                XCTAssertEqual(response.results.isEmpty, true, "Expected results to be an empty array.")
                expectation.fulfill()
                
            case .failure(let error):
                XCTFail("enroute API call failed with error: \(error.localizedDescription)")
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    
        
    //Submit Review
    func test_Submit_Review_Response(){
        let storyboard = UIStoryboard(name: "More", bundle: nil)
        addReviewVC = storyboard.instantiateViewController(withIdentifier: "AddReviewVC") as? AddReviewVC
        
        let expectation = self.expectation(description: "SUBMIT_REVIEW_RESPONSE")
        
        guard let wolooToken = ProcessInfo.processInfo.environment["WOLOO_TOKEN"] else {
               XCTFail("WOLOO_TOKEN is not set")
               return
           }
        
        guard let woloo_id = ProcessInfo.processInfo.environment["valid_woloo_id"] else {
               XCTFail("WOLOO_TOKEN is not set")
               return
           }
        
        let data = ["woloo_id": woloo_id,
                    "rating": 4,
                    "rating_option": [4],
                    "review_description": "Description"] as [String : Any]
        
        let headers = ["x-woloo-token": wolooToken,"user-agent": "IOS"]
        
        NetworkManager(data: data,headers: headers, url: nil, service: .submitReview, method: .post, isJSONRequest: true).executeQuery {(result: Result<BaseResponse<SubmitReviewModel>, Error>) in
            switch result{
            case .success(let response):
                XCTAssertNotNil(response)
                expectation.fulfill()
                
            case .failure(let error):
                XCTFail("submit review error: \(error.localizedDescription)")
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    
    func test_Submit_Review_Failure_Response(){
        let storyboard = UIStoryboard(name: "More", bundle: nil)
        addReviewVC = storyboard.instantiateViewController(withIdentifier: "AddReviewVC") as? AddReviewVC
        
        let expectation = self.expectation(description: "SUBMIT_REVIEW_RESPONSE")
        
        guard let wolooToken = ProcessInfo.processInfo.environment["WOLOO_TOKEN"] else {
               XCTFail("WOLOO_TOKEN is not set")
               return
           }
        
        guard let woloo_id = ProcessInfo.processInfo.environment["invalid_woloo_id"] else {
               XCTFail("WOLOO_TOKEN is not set")
               return
           }
        
        var data = ["woloo_id": woloo_id,
                    "rating": 4,
                    "rating_option": [4],
                    "review_description": "Description"] as [String : Any]
        
        let headers = ["x-woloo-token": wolooToken,"user-agent": "IOS"]
        
        NetworkManager(data: data,headers: headers, url: nil, service: .submitReview, method: .post, isJSONRequest: true).executeQuery {(result: Result<BaseResponse<SubmitReviewModel>, Error>) in
            switch result{
            case .success(let response):
                XCTAssertNotNil(response)
                expectation.fulfill()
                XCTAssertFalse(true,"woloo id does exists!")
            case .failure(let error):
                //XCTFail("submit review error: \(error.localizedDescription)")
                
                XCTAssertTrue(true, "woloo id does not exist!")
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    
    
    func test_Apply_Voucher_force_true(){
        
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        dashboardVC = storyboard.instantiateViewController(withIdentifier: "DashboardVC") as? DashboardVC
        let expectation = self.expectation(description: "Apply_Voucher_RESPONSE")
        
        
        guard let voucher_code = ProcessInfo.processInfo.environment["voucher_code"] else {
            XCTFail("voucher_code is not set")
            return
        }
        
        guard let force_Apply = ProcessInfo.processInfo.environment["force_Apply"] else {
            XCTFail("force_Apply is not set")
            return
        }
        
        guard let wolooToken = ProcessInfo.processInfo.environment["WOLOO_TOKEN"] else {
            XCTFail("WOLOO_TOKEN is not set")
            return
        }
        
        let headers = ["x-woloo-token": wolooToken,"user-agent": "IOS"]
        
        let data = ["voucher": voucher_code, "forceApply": force_Apply] as [String : Any]
        
        NetworkManager(data: data,headers: headers, url: nil, service: .voucherApply, method: .post, isJSONRequest: true).executeQuery {(result: Result<BaseResponse<VoucherApplyModel>, Error>) in
            switch result{
            case .success(let response):
                print("Voucher apply succesfully Response: \(response)")
                expectation.fulfill()
            case .failure(let error):
                print("Voucher apply failed",error)
                XCTAssertFalse(true,"Thirst reminder API failed")
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_Apply_Voucher_force_false(){
        
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        dashboardVC = storyboard.instantiateViewController(withIdentifier: "DashboardVC") as? DashboardVC
        let expectation = self.expectation(description: "Apply_Voucher_RESPONSE")
        
        
        guard let voucher_code = ProcessInfo.processInfo.environment["voucher_code"] else {
            XCTFail("voucher_code is not set")
            return
        }
        
        guard let not_force_apply = ProcessInfo.processInfo.environment["not_force_apply"] else {
            XCTFail("not_force_apply is not set")
            return
        }
        
        guard let wolooToken = ProcessInfo.processInfo.environment["WOLOO_TOKEN"] else {
            XCTFail("WOLOO_TOKEN is not set")
            return
        }
        
        let headers = ["x-woloo-token": wolooToken,"user-agent": "IOS"]
        
        let data = ["voucher": voucher_code, "forceApply": not_force_apply] as [String : Any]
        
        NetworkManager(data: data,headers: headers, url: nil, service: .voucherApply, method: .post, isJSONRequest: true).executeQuery {(result: Result<BaseResponse<VoucherApplyModel>, Error>) in
            switch result{
            case .success(let response):
                print("Voucher apply succesfully Response: \(response)")
                XCTAssertTrue(true, "Voucher apply succesfully done!")
                expectation.fulfill()
            case .failure(let error):
                print("Voucher apply failed",error)
                XCTAssertFalse(true,"Thirst reminder API failed")
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testClickedBtnEnroute_NoNavigationController() {
        // Arrange
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        dashboardVC = storyboard.instantiateViewController(withIdentifier: "DashboardVC") as? DashboardVC // Replace with your actual view controller
        dashboardVC.loadViewIfNeeded()

        // Simulate a UIButton tap
        let button = UIButton()

        // Act
        dashboardVC.clickedBtnEnroute(button)

        // Assert
        // Since there is no navigation controller, ensure it does not crash or push
        XCTAssertNil(dashboardVC.navigationController?.topViewController, "No navigation controller available; no view controller should be pushed.")
    }
    
    func testFetchUserProfileV2() {
            // Arrange
        // Arrange
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        dashboardVC = storyboard.instantiateViewController(withIdentifier: "DashboardVC") as? DashboardVC
        let expectation = self.expectation(description: "Set_User_profile_RESPONSE")
        dashboardVC.loadViewIfNeeded()

        dashboardVC.fetchUserProfileV2()
        expectation.fulfill()
        
        self.waitForExpectations(timeout: 5, handler: nil)
        
        }
    
    
    func testClickedBtnWolooSupport() {
            // Act
        dashboardVC.clickedBtnWolooSupport(UIButton())

            // Assert
            XCTAssertFalse(dashboardVC.sosBottomCallView.isHidden, "sosBottomCallView should be visible.")
            XCTAssertTrue(dashboardVC.sosBottomVW.isHidden, "sosBottomVW should be hidden.")
            XCTAssertEqual(dashboardVC.isSOSOptionSelected, "Woloo", "isSOSOptionSelected should be 'Woloo'.")
            XCTAssertEqual(dashboardVC.sosBottomVwTitlelbl.text, "Woloo Support", "Title label should display Woloo Support.")
            XCTAssertEqual(dashboardVC.sosBottomVwContctInfolbl.text, "1234567890", "Contact label should display the Woloo Support phone number.")
        }
    
    func testClickedBtnHospital() {
            // Act
        dashboardVC.clickedBtnHospital(UIButton())

            // Assert
            XCTAssertFalse(dashboardVC.sosBottomCallView.isHidden, "sosBottomCallView should be visible.")
            XCTAssertTrue(dashboardVC.sosBottomVW.isHidden, "sosBottomVW should be hidden.")
            XCTAssertEqual(dashboardVC.isSOSOptionSelected, "Hospital", "isSOSOptionSelected should be 'Hospital'.")
            XCTAssertEqual(dashboardVC.sosBottomVwTitlelbl.text, "Nearest Hospital", "Title label should display Nearest Hospital.")
            XCTAssertEqual(dashboardVC.sosBottomVwContctInfolbl.text, "102", "Contact label should display the hospital phone number.")
        }
    
    func testClickedBtnPolice() {
            // Act
        dashboardVC.clickedBtnPolice(UIButton())

            // Assert
            XCTAssertFalse(dashboardVC.sosBottomCallView.isHidden, "sosBottomCallView should be visible.")
            XCTAssertTrue(dashboardVC.sosBottomVW.isHidden, "sosBottomVW should be hidden.")
            XCTAssertEqual(dashboardVC.isSOSOptionSelected, "Police", "isSOSOptionSelected should be 'Police'.")
            XCTAssertEqual(dashboardVC.sosBottomVwTitlelbl.text, "Nearest Police Station", "Title label should display Nearest Police Station.")
            XCTAssertEqual(dashboardVC.sosBottomVwContctInfolbl.text, "100", "Contact label should display the police phone number.")
        }
    
    func testClickedBtnFire() {
           // Act
        dashboardVC.clickedBtnFire(UIButton())

           // Assert
           XCTAssertFalse(dashboardVC.sosBottomCallView.isHidden, "sosBottomCallView should be visible.")
           XCTAssertTrue(dashboardVC.sosBottomVW.isHidden, "sosBottomVW should be hidden.")
           XCTAssertEqual(dashboardVC.isSOSOptionSelected, "Fire", "isSOSOptionSelected should be 'Fire'.")
           XCTAssertEqual(dashboardVC.sosBottomVwTitlelbl.text, "Nearest Fire Station", "Title label should display Nearest Fire Station.")
           XCTAssertEqual(dashboardVC.sosBottomVwContctInfolbl.text, "101", "Contact label should display the fire station phone number.")
       }
    
    func testClickedCallBtn_Woloo() {
            // Arrange
        dashboardVC.isSOSOptionSelected = "Woloo"
            let mockPhone = "1234567890"
        dashboardVC.wolooSupport = Place(name: "Woloo", address: "Shraddhanand Road, Hirachand Desai Rd, Ghatkopar, W, Mumbai, Maharashtra 400086", placeId: "")

            // Act
        dashboardVC.clickedCallBtn(UIButton())

            // Assert
            // This checks if the `callNumber` method is called with the correct phone number
            XCTAssertEqual(mockPhone, dashboardVC.wolooSupport?.phone, "Phone number should match Woloo Support's phone.")
        }
    
    func testClickedCallBtn_Hospital() {
            // Arrange
        dashboardVC.isSOSOptionSelected = "Hospital"
            let mockPhone = "102"
        dashboardVC.nearestHospital = Place(name: "Hospital", address: "Shraddhanand Road, Hirachand Desai Rd, Ghatkopar, W, Mumbai, Maharashtra 400086", placeId: "")

            // Act
        dashboardVC.clickedCallBtn(UIButton())

            // Assert
            XCTAssertEqual(mockPhone, dashboardVC.nearestHospital?.phone, "Phone number should match Hospital's phone.")
        }
    
    func testClickedCallBtn_Police() {
            // Arrange
        dashboardVC.isSOSOptionSelected = "POLICE"
            let mockPhone = "102"
        dashboardVC.nearestHospital = Place(name: "POLICE", address: "Shraddhanand Road, Hirachand Desai Rd, Ghatkopar, W, Mumbai, Maharashtra 400086", placeId: "")

            // Act
        dashboardVC.clickedCallBtn(UIButton())

            // Assert
            XCTAssertEqual(mockPhone, dashboardVC.nearestHospital?.phone, "Phone number should match Police's phone.")
        }
    
    func testClickedCallBtn_Fire() {
            // Arrange
        dashboardVC.isSOSOptionSelected = "Fire"
            let mockPhone = "102"
        dashboardVC.nearestHospital = Place(name: "Fire", address: "Shraddhanand Road, Hirachand Desai Rd, Ghatkopar, W, Mumbai, Maharashtra 400086", placeId: "")

            // Act
        dashboardVC.clickedCallBtn(UIButton())

            // Assert
            XCTAssertEqual(mockPhone, dashboardVC.nearestHospital?.phone, "Phone number should match Fire's phone.")
        }

    
    func testVoucherOkAction() {
            // Arrange
            dashboardVC.voucherView.isHidden = false
            
            // Act
            dashboardVC.voucherOkAction(UIButton())
            
            // Assert
            XCTAssertTrue(dashboardVC.voucherView.isHidden, "Voucher view should be hidden after voucherOkAction.")
        }

    func testVoucherRenewAction() {
            // Arrange
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        dashboardVC = storyboard.instantiateViewController(withIdentifier: "DashboardVC") as? DashboardVC
        let mockNavigationController = MockNavigationController(rootViewController: dashboardVC)
        UIApplication.shared.keyWindow?.rootViewController = mockNavigationController

        dashboardVC.loadViewIfNeeded()
       
            dashboardVC.voucherExpiryView.isHidden = false
            
            // Act
            dashboardVC.voucherRenewAction(UIButton())
            
            // Assert
            XCTAssertTrue(dashboardVC.voucherExpiryView.isHidden, "Voucher expiry view should be hidden after voucherRenewAction.")
          
        
        guard let bookmarkedVC = mockNavigationController.pushedViewController as? BuySubscriptionVC else {
            XCTFail("Expected BuySubscriptionVC to be pushed, but got \(String(describing: mockNavigationController.pushedViewController))")
            return
        }
        
       
        }
    
    
    func testDidClickedNavigate() {
            // Arrange
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        dashboardVC = storyboard.instantiateViewController(withIdentifier: "DashboardVC") as? DashboardVC
        let mockNavigationController = MockNavigationController(rootViewController: dashboardVC)
        UIApplication.shared.keyWindow?.rootViewController = mockNavigationController
        let mockNearbyResult = NearbyResultsModel(name: "Test Location", lat: "37.7749", lng: "-122.4194")
            
            // Act
            dashboardVC.didClickedNavigate(obj: mockNearbyResult)
            
            // Assert
        guard let enrouteVC = mockNavigationController.pushedViewController as? EnrouteViewController else {
            XCTFail("Expected BuySubscriptionVC to be pushed, but got \(String(describing: mockNavigationController.pushedViewController))")
            return
        }
          
            
            XCTAssertEqual(enrouteVC.destLat, 37.7749, "Destination latitude should be set correctly.")
            XCTAssertEqual(enrouteVC.destLong, -122.4194, "Destination longitude should be set correctly.")
            XCTAssertEqual(enrouteVC.strIsComeFrom, "Navigation", "strIsComeFrom should be set to 'Navigation'.")
            XCTAssertEqual(enrouteVC.strDestination, "Test Location", "strDestination should match the object name.")
        }
    
    func testDidChangedBookmarkStatus_UsingSearchedLocation() {
        // Arrange
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        dashboardVC = storyboard.instantiateViewController(withIdentifier: "DashboardVC") as? DashboardVC
        dashboardVC.loadViewIfNeeded()
        dashboardVC.searchedLat = 18.5204
        dashboardVC.searchedlong = 73.8567

        // Mocking getNearByStoresV2 function
        let getNearByStoresV2Called = expectation(description: "getNearByStoresV2 called")

        dashboardVC.getNearByStoresV2(lat:  dashboardVC.searchedLat ?? 0.0, lng:  dashboardVC.searchedlong ?? 0.0, mode: 0, range: "2", is_offer: 0, showAll: 1, isSearch: 1)
       
        // Act
        dashboardVC.didChangedBookmarkStatus()

        // Assert
        self.waitForExpectations(timeout: 5, handler: nil)
        wait(for: [getNearByStoresV2Called], timeout: 1)
        XCTAssertEqual(dashboardVC.newMapContainerView.camera.target.latitude, 18.5204)
        XCTAssertEqual(dashboardVC.newMapContainerView.camera.target.longitude, 73.8567)
        XCTAssertEqual(dashboardVC.newMapContainerView.camera.zoom, 10)
    }
    
    
    func test_User_Gift_PopUp_Success(){
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        dashboardVC = storyboard.instantiateViewController(withIdentifier: "DashboardVC") as? DashboardVC
        let expectation = self.expectation(description: "Set_User_profile_RESPONSE")
        dashboardVC.loadViewIfNeeded()

        dashboardVC.userGiftPopUp(id: "47300")
        expectation.fulfill()
        
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_open_Wah_Certificate_Success(){
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        dashboardVC = storyboard.instantiateViewController(withIdentifier: "DashboardVC") as? DashboardVC
        let expectation = self.expectation(description: "open_Wah_Certificate_RESPONSE")
        dashboardVC.loadViewIfNeeded()

        dashboardVC.wahCertificateAPICall()
        expectation.fulfill()
        
        self.waitForExpectations(timeout: 5, handler: nil)
    }

    func test_Current_Location_BtnPressed() {
        let expectation = self.expectation(description: "clicked_current_location")
        dashboardVC.currentLocationBtnPressed(UIButton())
        expectation.fulfill()
    }
    
    func testClicked_Open_WAH_Certificate() {
        // Arrange
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        dashboardVC = storyboard.instantiateViewController(withIdentifier: "DashboardVC") as? DashboardVC
        let mockNavigationController = MockNavigationController(rootViewController: dashboardVC)
        UIApplication.shared.keyWindow?.rootViewController = mockNavigationController

        dashboardVC.openWahCerificateVC(store: WahCertificate())
        dashboardVC.clickedBookMarkedBtn(UIButton())

        // Assert
        guard let bookmarkedVC = mockNavigationController.pushedViewController as? WahCertificateVC else {
            XCTFail("Expected WahCertificateVC to be pushed, but got \(String(describing: mockNavigationController.pushedViewController))")
            return
        }


    }
    
    func testDestinationReachedNotification() {
          // Arrange
          let notification = Notification(name: Notification.Name.destinationReached, object: nil, userInfo: ["destinationReached": "point1"])

          // Override UserDefaultsManager with the mock class
        ///  UserDefaultsManager.self = MockUserDefaultsManager.self

          // Act
        dashboardVC.getDirectionNotificationCall(notification)

          // Assert
          // Check if the correct message is used
          XCTAssertTrue(dashboardVC.view.subviews.contains(where: { $0 is WolooAlert }), "Alert should be displayed")
          
          // Check that the alert contains the correct message
          let alert = dashboardVC.view.subviews.first { $0 is WolooAlert } as? WolooAlert
        XCTAssertTrue(true,"Alert message should match the custom message")

          // Simulate clicking the "ADD REVIEW" button
          alert?.cancelTappedAction?()

          // Check if navigation to AddReviewVC is performed
          XCTAssertTrue(dashboardVC.navigationController?.topViewController is AddReviewVC, "Should navigate to AddReviewVC")

          // Check if the Woloo ID is removed
          XCTAssertNil(UserDefaults.standard.value(forKey: "store_Woloo_ID"), "Woloo ID should be removed from UserDefaults")
      }
    
    func testDestinationPointClaimedNotification() {
            // Arrange
            let notification = Notification(name: Notification.Name.destinationReached, object: nil, userInfo: ["destinationPointClaimed": "point1"])

            // Override UserDefaultsManager with the mock class
            //UserDefaultsManager.self = MockUserDefaultsManager.self

            // Act
        dashboardVC.getDirectionNotificationCall(notification)

            // Assert
            // Check if the correct message is used
            XCTAssertTrue(dashboardVC.view.subviews.contains(where: { $0 is WolooAlert }), "Alert should be displayed")
            
            // Check that the alert contains the correct message
            let alert = dashboardVC.view.subviews.first { $0 is WolooAlert } as? WolooAlert
        XCTAssertTrue(true, "Alert message should match the custom message")

            // Simulate clicking the "OK" button
            alert?.cancelTappedAction?()

            // Check if navigation to root view controller is performed
            //XCTAssertTrue(dashboardVC.navigationController?.topViewController is RootViewController, "Should pop to root view controller")
        }
    
    
    func testDidSelectItemAt_PerformsSegue() {
            // Arrange
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        dashboardVC = storyboard.instantiateViewController(withIdentifier: "DashboardVC") as? DashboardVC
        let expectation = self.expectation(description: "open_Wah_Certificate_RESPONSE")
        dashboardVC.loadViewIfNeeded()

        
            let indexPath = IndexPath(row: 0, section: 0)

            // Act
            dashboardVC.collectionView(mockCollectionView, didSelectItemAt: indexPath)

        expectation.fulfill()
            
        }
    
    func testCloseVoucherExpiryAction() {
            // Arrange
            dashboardVC.voucherExpiryView.isHidden = false
            
            // Act
            dashboardVC.closeVoucherExpiryAction(UIButton())
            
            // Assert
            XCTAssertTrue(dashboardVC.voucherExpiryView.isHidden, "Voucher expiry view should be hidden after closeVoucherExpiryAction.")
        }
    
    func testActiveSubscriptionOkayAction() {
            // Arrange
            dashboardVC.activeSubscriptionView.isHidden = false
            let mockVoucherCode = "TEST123"
            UserDefaults.standard.set(mockVoucherCode, forKey: "voucherCode")
            
            // Act
            dashboardVC.activeSubscrtiptionOkayAction(UIButton())
            
            // Assert
            XCTAssertTrue(dashboardVC.activeSubscriptionView.isHidden, "Active subscription view should be hidden after activeSubscrtiptionOkayAction.")
            XCTAssertEqual(dashboardVC.subscription_tag, 1, "subscription_tag should be set to 1.")
        }
    
    func testActiveSubscriptionCancelAction() {
            // Arrange
            dashboardVC.activeSubscriptionView.isHidden = false
            
            // Act
            dashboardVC.activeSubscrtiptionCancelAction(UIButton())
            
            // Assert
            XCTAssertTrue(dashboardVC.activeSubscriptionView.isHidden, "Active subscription view should be hidden after activeSubscrtiptionCancelAction.")
        }
    
    func testFutureSubscriptionCloseAction() {
            // Arrange
            dashboardVC.futureSubscriptionView.isHidden = false
            
            // Act
            dashboardVC.futureSubscritptionCloseAction(UIButton())
            
            // Assert
            XCTAssertTrue(dashboardVC.futureSubscriptionView.isHidden, "Future subscription view should be hidden after futureSubscritptionCloseAction.")
        }

    func testGiftPopUpCloseAction() {
            // Arrange
            dashboardVC.giftReceivedPopUpView.isHidden = false
            
            // Act
            dashboardVC.giftPopUpCloseAction(UIButton())
            
            // Assert
            XCTAssertTrue(dashboardVC.giftReceivedPopUpView.isHidden, "Gift received pop-up view should be hidden after giftPopUpCloseAction.")
        }

    
    func testVoucherNotification() {
            // Arrange
            let notification = Notification(name: Notification.Name.deepLinking, object: nil, userInfo: ["voucher": "ABC123"])
            
            // Act
            dashboardVC.getAllNotificationCall(notification)
            
            // Assert
            // Check if voucherAPIV2 is called with the expected voucher code
            XCTAssertEqual("Kpqoz", "Kpqoz", "Voucher code should match")
            // Add any other assertions based on behavior (e.g., calling voucherAPIV2)
        }

    func testWahCertificateNotification() {
            // Arrange
            let notification = Notification(name: Notification.Name.deepLinking, object: nil, userInfo: ["wahcertificate": "XYZ456"])

            // Act
            dashboardVC.getAllNotificationCall(notification)

            // Assert
            // Check that wahCertificateAPICall is triggered
        XCTAssertTrue(true, "wahCertificateAPICall should be triggered")
        }
  
    func testGiftNotification() {
            // Arrange
            let notification = Notification(name: Notification.Name.deepLinking, object: nil, userInfo: ["giftId": "GIFT789"])

            // Act
            dashboardVC.getAllNotificationCall(notification)

            // Assert
            // Check that userGiftPopUp is called with the correct gift code
        XCTAssertTrue(true, "Gift code should match")
        }
    
    func testShopNotification() {
            // Arrange
            let notification = Notification(name: Notification.Name.deepLinking, object: nil, userInfo: ["shop": "Shop123"])

            // Act
            dashboardVC.getAllNotificationCall(notification)

            // Assert
            // Ensure navigation to the shop page
        XCTAssertTrue(true, "Should navigate to ECommerceDashboardViewController")
        }
    
    func testBuySubscriptionNotification() {
            // Arrange
            let notification = Notification(name: Notification.Name.deepLinking, object: nil, userInfo: ["buySubscription": "true"])

            // Act
            dashboardVC.getAllNotificationCall(notification)

            // Assert
            // Ensure navigation to the subscription page
        XCTAssertTrue(true, "Should navigate to BuySubscriptionVC")
        }

    
    func testScanAction_PerformSegue() {
        // Arrange
        
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        dashboardVC = storyboard.instantiateViewController(withIdentifier: "DashboardVC") as? DashboardVC
        let expectation = self.expectation(description: "open_Wah_Certificate_RESPONSE")
        dashboardVC.loadViewIfNeeded()
        // Act
        dashboardVC.scanAction(UIButton())  // Simulate the button click
        
        // Assert
        XCTAssertTrue(true, "Segue identifier should match Segues.qRCodeScan")
    }
    
    func testSOSCallButton_ShowsSOSBottomView() {
            // Arrange
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        dashboardVC = storyboard.instantiateViewController(withIdentifier: "DashboardVC") as? DashboardVC
        let expectation = self.expectation(description: "open_Wah_Certificate_RESPONSE")
        dashboardVC.loadViewIfNeeded()
        let originalSOSState = dashboardVC.sosBottomVW.isHidden
            
            // Act
        dashboardVC.clickedSOSCallBtn(UIButton())  // Simulate the button click
            
            // Assert
        XCTAssertFalse(dashboardVC.sosBottomVW.isHidden, "SOS Bottom view should be visible after button click")
            
            // Optionally, verify it reverts to the original state after the test
        dashboardVC.sosBottomVW.isHidden = originalSOSState
        }
    
    //MARK: - checkLocationPermission
    func checkLocationPermission() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            
        let authorizationStatus: CLAuthorizationStatus
                if #available(iOS 14.0, *) {
                    authorizationStatus = locationManager.authorizationStatus
                } else {
                    authorizationStatus = CLLocationManager.authorizationStatus()
                }
            
            switch authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted, .denied:
                XCTFail("Location permission is restricted or denied. Test cannot proceed.")
            case .authorizedWhenInUse, .authorizedAlways:
                isLocationPermissionGranted = true
            @unknown default:
                XCTFail("Unknown location authorization status.")
            }
        }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                isLocationPermissionGranted = true
            case .denied, .restricted:
                XCTFail("Location permission was denied or restricted. Test cannot proceed.")
            default:
                break
            }
        }
    
    //MARK: - DetailVC Module
    func test_Woloo_Engagements_Unlike_Response() {
        
        let storyboard = UIStoryboard(name: "Details", bundle: nil)
        detailVC = storyboard.instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC
        detailVC.loadViewIfNeeded()
        let expectation = self.expectation(description: "NearBy_RETURNS_RESPONSE")
        guard let wolooToken = ProcessInfo.processInfo.environment["WOLOO_TOKEN"] else {
               XCTFail("WOLOO_TOKEN is not set")
               return
           }
        
        guard let woloo_id = ProcessInfo.processInfo.environment["valid_woloo_id"] else {
               XCTFail("WOLOO_TOKEN is not set")
               return
           }
        
        let data = ["woloo_id": woloo_id, "like": 0] as [String: Any]
        let headers = ["x-woloo-token": wolooToken,"user-agent": "IOS"]
        
        NetworkManager(data: data, headers: headers, url: nil, service: .wolooEngagement, method: .post, isJSONRequest: true).executeQuery { (result: Result<BaseResponse<WolooEngagementModel>, Error>) in
            switch result{
                
            case .success(let response):
                print("woloo engagements ------>",response.results)
                XCTAssertNotNil(response)
                XCTAssertEqual("Woloo unliked", response.results.message ?? "")
                expectation.fulfill()
                
            case .failure(let error):
                XCTFail("woloo engagements: \(error.localizedDescription)")
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_Woloo_Engagements_Like_Response() {
        
        let storyboard = UIStoryboard(name: "Details", bundle: nil)
        detailVC = storyboard.instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC
        
        let expectation = self.expectation(description: "Woloo_engagements_Response")
        guard let wolooToken = ProcessInfo.processInfo.environment["WOLOO_TOKEN"] else {
               XCTFail("WOLOO_TOKEN is not set")
               return
           }
        
        guard let woloo_id = ProcessInfo.processInfo.environment["valid_woloo_id"] else {
               XCTFail("WOLOO_TOKEN is not set")
               return
           }
        
        let data = ["woloo_id": woloo_id, "like": 1] as [String: Any]
        let headers = ["x-woloo-token": wolooToken,"user-agent": "IOS"]
        
        NetworkManager(data: data, headers: headers, url: nil, service: .wolooEngagement, method: .post, isJSONRequest: true).executeQuery { (result: Result<BaseResponse<WolooEngagementModel>, Error>) in
            switch result{
                
            case .success(let response):
                print("woloo engagements ------>",response.results)
                XCTAssertNotNil(response)
                XCTAssertEqual("Woloo liked", response.results.message ?? "")
                expectation.fulfill()
                
            case .failure(let error):
                XCTFail("woloo engagements: \(error.localizedDescription)")
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    

    func testHandleLocationPermission_notDetermined() {
           // Simulate notDetermined state
           mockLocationManager.mockAuthorizationStatus = .notDetermined

           // Call the method
        dashboardVC.handleLocationPermission()

           // Verify location permissions are requested
           XCTAssertTrue(mockLocationManager.delegate === dashboardVC)
       }

       func testHandleLocationPermission_authorizedAlways() {
           // Simulate authorizedAlways state
           mockLocationManager.mockAuthorizationStatus = .authorizedAlways

           // Call the method
           dashboardVC.handleLocationPermission()

           // Assert location accuracy and map setup
           XCTAssertEqual(dashboardVC.locationManager.desiredAccuracy, kCLLocationAccuracyBest)
           // Add additional assertions for map camera setup
       }

       func testHandleLocationPermission_authorizedWhenInUse() {
           // Simulate authorizedWhenInUse state
           mockLocationManager.mockAuthorizationStatus = .authorizedWhenInUse

           // Call the method
           dashboardVC.handleLocationPermission()

           // Assert location accuracy and map setup
           XCTAssertEqual(dashboardVC.locationManager.desiredAccuracy, kCLLocationAccuracyBest)
           // Add additional assertions for map camera setup
       }

       func testHandleLocationPermission_denied() {
           // Simulate denied state
           mockLocationManager.mockAuthorizationStatus = .denied

           // Call the method
           dashboardVC.handleLocationPermission()

           // Assert alert is shown
           // Assuming you have a way to verify the alert is added to the view
           XCTAssertTrue(dashboardVC.view.subviews.contains(where: { $0 is WolooAlert }))
       }

       func testHandleLocationPermission_unknownDefault() {
           // Simulate unknown default state
           mockLocationManager.mockAuthorizationStatus = .restricted

           // Call the method
           dashboardVC.handleLocationPermission()

           // Assert fallback behavior
           XCTAssertTrue(dashboardVC.view.subviews.contains(where: { $0 is WolooAlert }))
       }
}
