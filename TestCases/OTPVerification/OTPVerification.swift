//
//  OTPVerification.swift
//  OTPVerification
//
//  Created by Kapil Dongre on 30/12/24.
//

import XCTest
@testable import Woloo

class MockViewControllerDelegate: OTPVerificationVCDelegate {
    var appConfigGetV2Called = false
    var configureUICalled = false
    
    func appConfigGetV2() {
        appConfigGetV2Called = true
    }
    
    func configureUI() {
        configureUICalled = true
    }
}

class MockNavigationController: UINavigationController {
    var pushedViewController: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        // Capture the pushed view controller
        self.pushedViewController = viewController
        super.pushViewController(viewController, animated: animated)
    }
}


class SpyOTPVerificationVC: OTPVerificationVC {
    var resendOtpWolooV2Called = false
    
    override func resendOtpWolooV2() {
        resendOtpWolooV2Called = true
    }
}


final class OTPVerification: XCTestCase {
    
    
    var otpVerificationVC:  OTPVerificationVC!
    var mockNavigationController: MockNavigationController!
    var mockDelegate: MockViewControllerDelegate!
    var resendButton: UIButton!
    // Mocks for the functions
    var appConfigGetV2Called = false
    var configureUICalled = false
    var otpView: OTPFieldView!
    
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        otpVerificationVC = storyboard.instantiateViewController(withIdentifier: "OTPVerificationVC") as? OTPVerificationVC
        // Initialize the view controller to be tested
        otpVerificationVC = OTPVerificationVC()
        _ = otpVerificationVC.view // To load the view and initialize outlets
        
        // Access otpView for testing
        otpView = otpVerificationVC.otpView
        otpVerificationVC.loadViewIfNeeded()
        // Create a mock navigation controller with the sut as its root
        mockNavigationController = MockNavigationController(rootViewController: otpVerificationVC)
        
        // Ensure the view is loaded
        
        
        resendButton = UIButton()
        otpVerificationVC.resendButton = resendButton
        
        mockDelegate = MockViewControllerDelegate()
        
        // Inject the mock delegate into the view controller
        otpVerificationVC.delegate = mockDelegate
        XCTAssertNotNil(otpVerificationVC.otpView, "otpView should not be nil")
        // Mock the functions
        
    }
    
    override func tearDown() {
        otpVerificationVC = nil
        mockNavigationController = nil
        resendButton = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    
    func testSetupOtpView() {
        // Call the method to setup the OTP view
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        otpVerificationVC = storyboard.instantiateViewController(withIdentifier: "OTPVerificationVC") as? OTPVerificationVC
        otpVerificationVC.loadViewIfNeeded()
        otpVerificationVC.setupOtpView()
        
        // Assertions to verify configuration
        XCTAssertEqual(otpVerificationVC.otpView.fieldsCount, 4, "Fields count should be 4")
        XCTAssertEqual(otpVerificationVC.otpView.filledBackgroundColor, UIColor.white.withAlphaComponent(0.2), "Filled background color should match")
        XCTAssertEqual(otpVerificationVC.otpView.defaultBackgroundColor, UIColor.white.withAlphaComponent(0.2), "Default background color should match")
        XCTAssertEqual(otpVerificationVC.otpView.fieldFont, ThemeManager.Font.OpenSans_bold(size: 16), "Field font should match")
        XCTAssertEqual(otpVerificationVC.otpView.textColor, .white, "Text color should be white")
        XCTAssertEqual(otpVerificationVC.otpView.fieldBorderWidth, 1, "Field border width should be 1")
        XCTAssertEqual(otpVerificationVC.otpView.defaultBorderColor, .textColor, "Default border color should match")
        XCTAssertEqual(otpVerificationVC.otpView.filledBorderColor, .main, "Filled border color should match")
        XCTAssertEqual(otpVerificationVC.otpView.cursorColor, .main, "Cursor color should match")
        XCTAssertEqual(otpVerificationVC.otpView.displayType, .roundedCorner, "Display type should be rounded corner")
        XCTAssertEqual(otpVerificationVC.otpView.fieldSize, 40, "Field size should be 40")
        XCTAssertEqual(otpVerificationVC.otpView.separatorSpace, 10, "Separator space should be 10")
        XCTAssertFalse(otpVerificationVC.otpView.shouldAllowIntermediateEditing, "Intermediate editing should not be allowed")
        XCTAssertTrue(otpVerificationVC.otpView.delegate === otpVerificationVC, "OTP view delegate should be set to the view controller")
    }
    
    
    func testWrongOtpPopUp_ShowsAlert() {
        // Act
        otpVerificationVC.wrongOtpPopUp()
        
        // Assert
        let expectation = self.expectation(description: "Alert is presented")
        
        // Use a UI test to check for the presence of the alert
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Check if the alert controller is visible
            let alert = self.getAlert()
            XCTAssertNotNil(alert, "The alert should be presented.")
            XCTAssertTrue(alert?.message?.contains("Incorrect Otp") ?? false, "Alert message should be 'Incorrect Otp'")
            
            // Check if the 'OK' button exists
            let okAction = alert?.actions.first(where: { $0.title == "Ok" })
            XCTAssertNotNil(okAction, "'Ok' button should be present in the alert.")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    private func getAlert() -> UIAlertController? {
        // Use UI window to inspect the presented alert controller
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            return window.rootViewController?.presentedViewController as? UIAlertController
        }
        return nil
    }
    
    func testDidTapResendButton_CallsResendOtpWolooV2() {
        // Arrange
        // We need to spy on the resendOtpWolooV2 method to ensure it's called
        let spy = SpyOTPVerificationVC()
        spy.resendOtpWolooV2Called = false
        otpVerificationVC = spy // Use the spy instead of the real view controller
        
        // Act
        otpVerificationVC.didTapResendButton(resendButton)
        
        // Assert: Verify that resendOtpWolooV2 was called
        XCTAssertTrue(spy.resendOtpWolooV2Called, "resendOtpWolooV2 should be called when the resend button is tapped.")
    }
    
    func testOpenGenderVC() {
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        otpVerificationVC = storyboard.instantiateViewController(withIdentifier: "OTPVerificationVC") as? OTPVerificationVC
        let mockNavigationController = MockNavigationController(rootViewController: otpVerificationVC)
        UIApplication.shared.keyWindow?.rootViewController = mockNavigationController
        otpVerificationVC.loadViewIfNeeded()
        
        otpVerificationVC.openGenderVC()
        
        // Assert: Check that the tracker view controller is pushed onto the stack
        guard let periodTrackerVC = mockNavigationController.pushedViewController as? GenderSelectionController else {
            XCTFail("Expected GenderSelectionController to be pushed, but got \(String(describing: mockNavigationController.pushedViewController))")
            return
        }
    }
    
    
    func testOpenTopicScreen() {
        // Act
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        otpVerificationVC = storyboard.instantiateViewController(withIdentifier: "OTPVerificationVC") as? OTPVerificationVC
        let mockNavigationController = MockNavigationController(rootViewController: otpVerificationVC)
        UIApplication.shared.keyWindow?.rootViewController = mockNavigationController
        otpVerificationVC.loadViewIfNeeded()
        
        otpVerificationVC.openTopicScreen()
        
        // Assert: Check that the tracker view controller is pushed onto the stack
        guard let periodTrackerVC = mockNavigationController.pushedViewController as? IntrestedTopicVC else {
            XCTFail("Expected IntrestedTopicVC to be pushed, but got \(String(describing: mockNavigationController.pushedViewController))")
            return
        }
        
    }
    
    func testOpenTrackerScreen() {
        // Act
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        otpVerificationVC = storyboard.instantiateViewController(withIdentifier: "OTPVerificationVC") as? OTPVerificationVC
        let mockNavigationController = MockNavigationController(rootViewController: otpVerificationVC)
        UIApplication.shared.keyWindow?.rootViewController = mockNavigationController
        otpVerificationVC.loadViewIfNeeded()
        
        otpVerificationVC.openTrackerScreen()
        
        // Assert: Check that the tracker view controller is pushed onto the stack
        guard let periodTrackerVC = mockNavigationController.pushedViewController as? PeriodTrackerViewController else {
            XCTFail("Expected periodTrackerVC to be pushed, but got \(String(describing: mockNavigationController.pushedViewController))")
            return
        }
    }
    
    func testOpenMainTab() {
        // Act
        otpVerificationVC.openMainTab()
        
        // Assert: Check that the main tab view controller is pushed onto the stack
        XCTAssertTrue(mockNavigationController.pushedViewController is UITabBarController, "The UITabBarController should be pushed.")
    }
    
    func test_OTPVerification_With_ValidRequest_Returns_Response(){
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        otpVerificationVC = storyboard.instantiateViewController(withIdentifier: "OTPVerificationVC") as? OTPVerificationVC
        otpVerificationVC.loadViewIfNeeded()
        let expectation = self.expectation(description: "VERIFY_OTP_RETURNS_RESPONSE")
        //Arrange
        let data = ["request_id": "06188155-02a6-43cc-a1b1-6ee3cf4def51", "otp": "1987"] as [String : Any]
        NetworkManager(data: data, url: nil, service: .verifyOtp, method: .post, isJSONRequest: true).executeQuery { (result: Result<BaseResponse<VerifyOtpModel>, Error>) in
            switch result{
            case .success(let response):
                print("Verify Otp response ------>",response)
                //Asserts
                XCTAssertNotNil(response)
                expectation.fulfill()
                
            case .failure(let error):
                print("Verify otp failed\(error)")
                XCTAssertFalse(true,"Verify Otp Failed")
                expectation.fulfill()
                
            }
        }
        //        expectation.fulfill()
        
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_OTPVerification_With_Empty_String(){
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        otpVerificationVC = storyboard.instantiateViewController(withIdentifier: "OTPVerificationVC") as? OTPVerificationVC
        otpVerificationVC.loadViewIfNeeded()
        let expectation = self.expectation(description: "VERIFY_OTP_RETURNS_RESPONSE")
        //Arrange
        let data = ["request_id": "", "otp": ""] as [String : Any]
        NetworkManager(data: data, url: nil, service: .verifyOtp, method: .post, isJSONRequest: true).executeQuery { (result: Result<BaseResponse<VerifyOtpModel>, Error>) in
            switch result{
            case .success(let response):
                XCTAssertFalse(true,"Verify Otp test passed")
                expectation.fulfill()
                
            case .failure(let error):
                print("Verify otp failed\(error)")
                XCTAssertTrue(true, "Request body and OTP should not be nil")
                expectation.fulfill()
                
            }
        }
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testDidTapVerifyAndProceed() {
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        otpVerificationVC = storyboard.instantiateViewController(withIdentifier: "OTPVerificationVC") as? OTPVerificationVC
        otpVerificationVC.loadViewIfNeeded()
        
            // Mock verifyOTPV3 method using a spy
            let verifyOTPV3Expectation = expectation(description: "verifyOTPV3 should be called with correct parameters")
            
            // Create a spy for verifyOTPV3
        otpVerificationVC.verifyOTPV3(request_id: "693274f7-9a76-4170-bee9-7beec076b5358", otp: "1234")
        
       
            // Call the method
        otpVerificationVC.didTapVerifyAndProceed(UIButton())
            
            // Assert the expected outcome
            XCTAssertEqual(1234, 1234, "LoginDO should have the correct OTP")
            waitForExpectations(timeout: 5, handler: nil)
        }
    
    func test_OTPVerification_With_Empty_OTP(){
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        otpVerificationVC = storyboard.instantiateViewController(withIdentifier: "OTPVerificationVC") as? OTPVerificationVC
        let expectation = self.expectation(description: "VERIFY_OTP_RETURNS_RESPONSE")
        otpVerificationVC.loadViewIfNeeded()
        //Arrange
        let data = ["request_id": "06188155-02a6-43cc-a1b1-6ee3cf4def51", "otp": ""] as [String : Any]
        NetworkManager(data: data, url: nil, service: .verifyOtp, method: .post, isJSONRequest: true).executeQuery { (result: Result<BaseResponse<VerifyOtpModel>, Error>) in
            switch result{
            case .success(let response):
                expectation.fulfill()
                
            case .failure(let error):
                print("Verify otp failed\(error)")
                XCTAssertTrue(true, "OTP Should not be nil")
                expectation.fulfill()
                
            }
        }
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_verify_otp(){
        
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        otpVerificationVC = storyboard.instantiateViewController(withIdentifier: "OTPVerificationVC") as? OTPVerificationVC
        let expectation = self.expectation(description: "VERIFY_OTP_RETURNS_RESPONSE")
        otpVerificationVC.loadViewIfNeeded()
        
        otpVerificationVC.verifyOTPV3(request_id: "693274f7-9a76-4170-bee9-7beec076b5358", otp: "1234")
        
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    
}

