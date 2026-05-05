//
//  HomeDashboardTests.swift
//  HomeDashboardTests
//
//  Created by Kapil Dongre on 30/12/24.
//

import XCTest
@testable import Woloo

final class HomeDashboardTests: XCTestCase {

    var wolooDashboard: WolooDashBoardVC!
    var viewPeriodTracker: PeriodTrackerViewController!
    
    func testEditThirstReminderSetHours(){
        
        let storyboard = UIStoryboard(name: "WolooDashBoard", bundle: nil)
        wolooDashboard = storyboard.instantiateViewController(withIdentifier: "WolooDashBoardVC") as? WolooDashBoardVC
        let expectation = self.expectation(description: "Edit_Thirst_Reminder_RESPONSE")
        
        
        guard let is_thirst_reminder = ProcessInfo.processInfo.environment["is_thirst_reminder_yes"] else {
               XCTFail("thirst reminder is not set")
               return
           }
        
        guard let thirst_reminder_hours = ProcessInfo.processInfo.environment["thirst_reminder_frequency"] else {
               XCTFail("thirst_reminder_hours is not set")
               return
           }
        let data = ["is_thirst_reminder": is_thirst_reminder,
                    "thirst_reminder_hours": thirst_reminder_hours] as [String : Any]
        
        guard let wolooToken = ProcessInfo.processInfo.environment["WOLOO_TOKEN"] else {
               XCTFail("WOLOO_TOKEN is not set")
               return
           }
        
        let headers = ["x-woloo-token": wolooToken,"user-agent": "IOS"]
        
        NetworkManager(data: data, headers: headers, url: nil, service: .thirstReminder, method: .post, isJSONRequest: true).executeQuery { (result: Result<BaseResponse<ThirstReminderModel>, Error>) in
            switch result{
            case .success(let response):
                print("Thirst reminder response: \(response)")
                XCTAssertNotNil(response.results)
                expectation.fulfill()
           
                
            case .failure(let error):
                print("Error thirst reminder \(error)")
                XCTAssertFalse(true,"Thirst reminder API failed")
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 10, handler: nil)
    }

    func testEditThirstReminderDisableHours(){
        
        let storyboard = UIStoryboard(name: "WolooDashBoard", bundle: nil)
        wolooDashboard = storyboard.instantiateViewController(withIdentifier: "WolooDashBoardVC") as? WolooDashBoardVC
        let expectation = self.expectation(description: "Edit_Thirst_Reminder_RESPONSE")
        
        
        guard let is_thirst_reminder = ProcessInfo.processInfo.environment["is_thirst_reminder_no"] else {
               XCTFail("thirst reminder is not set")
               return
           }
        
        guard let thirst_reminder_hours = ProcessInfo.processInfo.environment["thirst_reminder_frequency"] else {
               XCTFail("thirst_reminder_hours is not set")
               return
           }
        let data = ["is_thirst_reminder": is_thirst_reminder,
                    "thirst_reminder_hours": thirst_reminder_hours] as [String : Any]
        
        guard let wolooToken = ProcessInfo.processInfo.environment["WOLOO_TOKEN"] else {
               XCTFail("WOLOO_TOKEN is not set")
               return
           }
        
        let headers = ["x-woloo-token": wolooToken,"user-agent": "IOS"]
        
        NetworkManager(data: data, headers: headers, url: nil, service: .thirstReminder, method: .post, isJSONRequest: true).executeQuery { (result: Result<BaseResponse<ThirstReminderModel>, Error>) in
            switch result{
            case .success(let response):
                print("Thirst reminder response: \(response)")
                XCTAssertNotNil(response.results)
                expectation.fulfill()
           
                
            case .failure(let error):
                print("Error thirst reminder \(error)")
                XCTAssertFalse(true,"Thirst reminder API failed")
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testgetBlogsForUserByShop(){
        let storyboard = UIStoryboard(name: "WolooDashBoard", bundle: nil)
        wolooDashboard = storyboard.instantiateViewController(withIdentifier: "WolooDashBoardVC") as? WolooDashBoardVC
        let expectation = self.expectation(description: "Edit_Thirst_Reminder_RESPONSE")
        
        guard let wolooToken = ProcessInfo.processInfo.environment["WOLOO_TOKEN"] else {
               XCTFail("WOLOO_TOKEN is not set")
               return
           }
        
        guard let blog_category_shop = ProcessInfo.processInfo.environment["blog_category_shop"] else {
               XCTFail("blog_category_shop is not set")
               return
           }
        
        let headers = ["x-woloo-token": wolooToken,"user-agent": "IOS"]
        
        let localeData = [ "category" : "All",
                           "page" : "1","shop_display": blog_category_shop] as [String : Any]
        
        
        NetworkManager(data: localeData, headers: headers, url: nil, service: .getBlogsForShop, method: .post, isJSONRequest: true).executeQuery { (result: Result<BaseResponse<BlogDetailModel>, Error>) in
            switch result{
                
            case .success(let response):
                print("getBlogsForShop response: ",response)
                XCTAssertNotNil(response.results.blogs)
                expectation.fulfill()
                
            case .failure(let error):
                print("Error getBlogsForShop reminder \(error)")
                XCTAssertFalse(true,"getBlogsForShop  API failed")
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testgetBlogsForUserByBlogs(){
        let storyboard = UIStoryboard(name: "WolooDashBoard", bundle: nil)
        wolooDashboard = storyboard.instantiateViewController(withIdentifier: "WolooDashBoardVC") as? WolooDashBoardVC
        let expectation = self.expectation(description: "get_blogs_RESPONSE")
        
        guard let wolooToken = ProcessInfo.processInfo.environment["WOLOO_TOKEN"] else {
               XCTFail("WOLOO_TOKEN is not set")
               return
           }
        
        guard let blog_category_blogs = ProcessInfo.processInfo.environment["blog_category_blogs"] else {
               XCTFail("blog_category_blogs is not set")
               return
           }
        
        let headers = ["x-woloo-token": wolooToken,"user-agent": "IOS"]
        
        let localeData = [ "category" : "All",
                           "page" : "1","shop_display": blog_category_blogs] as [String : Any]
        
        
        NetworkManager(data: localeData, headers: headers, url: nil, service: .getBlogsForShop, method: .post, isJSONRequest: true).executeQuery { (result: Result<BaseResponse<BlogDetailModel>, Error>) in
            switch result{
                
            case .success(let response):
                print("blog_category_blogs response: ",response)
                XCTAssertNotNil(response.results.blogs)
                expectation.fulfill()
                
            case .failure(let error):
                print("Error blog_category_blogs reminder \(error)")
                XCTAssertFalse(true,"blog_category_blogs  API failed")
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testgetBlogsForUserByPeriods(){
        let storyboard = UIStoryboard(name: "WolooDashBoard", bundle: nil)
        wolooDashboard = storyboard.instantiateViewController(withIdentifier: "WolooDashBoardVC") as? WolooDashBoardVC
        let expectation = self.expectation(description: "get_blogs_RESPONSE")
        
        guard let wolooToken = ProcessInfo.processInfo.environment["WOLOO_TOKEN"] else {
               XCTFail("WOLOO_TOKEN is not set")
               return
           }
        
        guard let blog_category_periods = ProcessInfo.processInfo.environment["blog_category_periods"] else {
               XCTFail("blog_category_periods is not set")
               return
           }
        
        let headers = ["x-woloo-token": wolooToken,"user-agent": "IOS"]
        
        let localeData = [ "category" : "All",
                           "page" : "1","shop_display": blog_category_periods] as [String : Any]
        
        
        NetworkManager(data: localeData, headers: headers, url: nil, service: .getBlogsForShop, method: .post, isJSONRequest: true).executeQuery { (result: Result<BaseResponse<BlogDetailModel>, Error>) in
            switch result{
                
            case .success(let response):
                print("blog_category_periods response: ",response)
                XCTAssertNotNil(response.results.blogs)
                expectation.fulfill()
                
            case .failure(let error):
                print("Error blog_category_periods reminder \(error)")
                XCTAssertFalse(true,"blog_category_periods  API failed")
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 10, handler: nil)
    }
}
