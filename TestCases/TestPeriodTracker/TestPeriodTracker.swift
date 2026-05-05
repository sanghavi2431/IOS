//
//  TestPeriodTracker.swift
//  TestPeriodTracker
//
//  Created by Kapil Dongre on 30/12/24.
//

import XCTest
@testable import Woloo

final class TestPeriodTracker: XCTestCase {

    var periodTracker: PeriodTrackerViewController!
    var editperiodTracker: EditCycleViewController!
    
    func test_viewPeriodTracker(){
        let storyboard = UIStoryboard(name: "Tracker", bundle: nil)
        periodTracker = storyboard.instantiateViewController(withIdentifier: "PeriodTrackerViewController") as? PeriodTrackerViewController
        
        let expectation = self.expectation(description: "View_Period_Tracker_RESPONSE")
        
        guard let wolooToken = ProcessInfo.processInfo.environment["WOLOO_TOKEN"] else {
               XCTFail("WOLOO_TOKEN is not set")
               return
           }
        
        let headers = ["x-woloo-token": wolooToken,"user-agent": "IOS"]
        
        NetworkManager(headers: headers, url: nil, service: .viewperiodtracker, method: .get, isJSONRequest: false).executeQuery {(result: Result<BaseResponse<ViewPeriodTrackerModel>, Error>) in
            switch result{
            case .success(let response):
                print("View Period Tracker response: \(response)")
                XCTAssertNotNil(response.results)
                expectation.fulfill()
                
            case .failure(let error):
                print("Error view period tracker \(error)")
                XCTAssertFalse(true,"view period tracker failed")
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_edit_Period_Tracker_success(){
        
        let storyboard = UIStoryboard(name: "Tracker", bundle: nil)
        editperiodTracker = storyboard.instantiateViewController(withIdentifier: "EditCycleViewController") as? EditCycleViewController
        let expectation = self.expectation(description: "Edit_Period_Tracker_RESPONSE")
        
        guard let wolooToken = ProcessInfo.processInfo.environment["WOLOO_TOKEN"] else {
               XCTFail("WOLOO_TOKEN is not set")
               return
           }
        
        guard let period_cycleLength = ProcessInfo.processInfo.environment["period_cycleLength_Valid"] else {
               XCTFail("period_cycleLength is not set")
               return
           }
        //period_cycleLength_Invalid
        guard let periodDate = ProcessInfo.processInfo.environment["periodDate"] else {
               XCTFail("periodDate is not set")
               return
           }
        
        guard let periodLength = ProcessInfo.processInfo.environment["periodLength_Valid"] else {
               XCTFail("periodLength is not set")
               return
           }
        //periodLength_Invalid
        
        guard let lutealLength = ProcessInfo.processInfo.environment["lutealLength"] else {
               XCTFail("lutealLength is not set")
               return
           }
        
        
        if Int(periodLength) ?? 0 < 2 || Int(periodLength) ?? 0 > 5 {
            XCTAssertFalse(true,"Bleeding Days should be between 2-5 days")
        }
        else if Int(period_cycleLength) ?? 0 < 24 || Int(period_cycleLength) ?? 0 > 35 {
            XCTAssertFalse(true,"Cycle Length should be between 24-35 days")
        }
        
        let data = ["period_date": periodDate,
                    "cycle_length": period_cycleLength,
                    "period_length": periodLength,
                    "luteal_length": lutealLength,"log": ["": ""]] as [String : Any]
        let headers = ["x-woloo-token": wolooToken,"user-agent": "IOS"]
        
        NetworkManager(data: data, headers: headers, url: nil, service: .editPeriodTracker, method: .post, isJSONRequest: true).executeQuery { (result: Result<BaseResponse<ViewPeriodTrackerModel>, Error>) in
            switch result{
            case .success(let response):
                print("Edit period tracker response: \(response)")

                XCTAssertNotNil(response.results)
                expectation.fulfill()
                
            case .failure(let error):
                print("Error Edit period Tracker \(error)")
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
//    func test_edit_Period_Tracker_success() {
//        let storyboard = UIStoryboard(name: "Tracker", bundle: nil)
//        editperiodTracker = storyboard.instantiateViewController(withIdentifier: "EditCycleViewController") as? EditCycleViewController
//        let expectation = self.expectation(description: "Edit_Period_Tracker_RESPONSE")
//        
//        guard let wolooToken = ProcessInfo.processInfo.environment["WOLOO_TOKEN"] else {
//               XCTFail("WOLOO_TOKEN is not set")
//               return
//           }
//        
//        guard let period_cycleLength = ProcessInfo.processInfo.environment["period_cycleLength_Valid"] else {
//               XCTFail("period_cycleLength is not set")
//               return
//           }
//        //period_cycleLength_Invalid
//        guard let periodDate = ProcessInfo.processInfo.environment["periodDate"] else {
//               XCTFail("periodDate is not set")
//               return
//           }
//        
//        guard let periodLength = ProcessInfo.processInfo.environment["periodLength_Valid"] else {
//               XCTFail("periodLength is not set")
//               return
//           }
//        //periodLength_Invalid
//        
//        guard let lutealLength = ProcessInfo.processInfo.environment["lutealLength"] else {
//               XCTFail("lutealLength is not set")
//               return
//           }
//        
//        // Validate inputs using the controller's validation logic
//        let validation = editperiodTracker?.validatePeriodTrackingInputs(selectedDate: Date(), periodLength: Int(periodLength), cycleLength: Int(period_cycleLength))
//        if validation?.isValid == false {
//            XCTFail(validation?.errorMessage ?? "Validation failed")
//            return
//        }
//        
//        let data = ["period_date": periodDate,
//                    "cycle_length": period_cycleLength,
//                    "period_length": periodLength,
//                    "luteal_length": lutealLength,"log": ["": ""]] as [String : Any]
//        let headers = [
//            "x-woloo-token": wolooToken,
//            "user-agent": "IOS"
//        ]
//        
//        NetworkManager(data: data, headers: headers, url: nil, service: .editPeriodTracker, method: .post, isJSONRequest: true).executeQuery { (result: Result<BaseResponse<ViewPeriodTrackerModel>, Error>) in
//            switch result {
//            case .success(let response):
//                print("Edit period tracker response: \(response)")
//                XCTAssertNotNil(response.results)
//                expectation.fulfill()
//                
//            case .failure(let error):
//                XCTFail("Error Edit period Tracker \(error.localizedDescription)")
//                expectation.fulfill()
//            }
//        }
//        
//        self.waitForExpectations(timeout: 5, handler: nil)
//    }
    
    
    func test_edit_Period_Tracker_failure(){
        
        let storyboard = UIStoryboard(name: "Tracker", bundle: nil)
        editperiodTracker = storyboard.instantiateViewController(withIdentifier: "EditCycleViewController") as? EditCycleViewController
        let expectation = self.expectation(description: "Edit_Period_Tracker_RESPONSE")
        
        guard let wolooToken = ProcessInfo.processInfo.environment["WOLOO_TOKEN"] else {
               XCTFail("WOLOO_TOKEN is not set")
               return
           }
        
        guard let period_cycleLength = ProcessInfo.processInfo.environment["period_cycleLength_Invalid"] else {
               XCTFail("period_cycleLength is not set")
               return
           }
        //period_cycleLength_Invalid
        guard let periodDate = ProcessInfo.processInfo.environment["periodDate"] else {
               XCTFail("periodDate is not set")
               return
           }
        
        guard let periodLength = ProcessInfo.processInfo.environment["periodLength_Invalid"] else {
               XCTFail("periodLength is not set")
               return
           }
        //periodLength_Invalid
        
        guard let lutealLength = ProcessInfo.processInfo.environment["lutealLength"] else {
               XCTFail("lutealLength is not set")
               return
           }
        
        let validation = editperiodTracker?.validatePeriodTrackingInputs(selectedDate: Date(), periodLength: Int(periodLength), cycleLength: Int(period_cycleLength))
        if validation?.isValid == false {
            XCTFail(validation?.errorMessage ?? "Validation failed")
            return
        }

        let data = ["period_date": periodDate,
                    "cycle_length": period_cycleLength,
                    "period_length": periodLength,
                    "luteal_length": lutealLength,"log": ["": ""]] as [String : Any]
        let headers = ["x-woloo-token": wolooToken,"user-agent": "IOS"]
        
        NetworkManager(data: data, headers: headers, url: nil, service: .editPeriodTracker, method: .post, isJSONRequest: true).executeQuery { (result: Result<BaseResponse<ViewPeriodTrackerModel>, Error>) in
            switch result{
            case .success(let response):
                print("Edit period tracker response: \(response)")
                print("Edit Period Tracker response: \(response)")
                XCTAssertNotNil(response.results)
                expectation.fulfill()
                
            case .failure(let error):
                print("Error Edit period Tracker \(error)")
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 5, handler: nil)
    }
}
