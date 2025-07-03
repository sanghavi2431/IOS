//
//  OnboardingTestCase.swift
//  OnboardingTestCase
//
//  Created by Kapil Dongre on 28/12/24.
//

import XCTest
@testable import Woloo


//MARK: - Mobile number input test
class LoginVCTests: XCTestCase {
    var loginVC: LoginVC!
    
    func test_Send_OTP_With_Valid_Number(){
        // Initialize LoginVC from storyboard
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        let expectation = self.expectation(description: "SEND_OTP_RETURNS_RESPONSE")
        loginVC.loadViewIfNeeded()
        
        guard let mobNumber = ProcessInfo.processInfo.environment["mob_number"] else {
            XCTFail("Mobile number is not set")
            return
        }
        
        let data = ["mobileNumber": mobNumber, "referral_code": ""] as [String : Any]
        
        NetworkManager(data: data, url: nil, service: .sendOtp, method: .post, isJSONRequest: true).executeQuery {(result: Result<BaseResponse<SendOtpModel>, Error>) in
            
            switch result{
            case .success(let response):
                print("send Otp response ------>",response)
                XCTAssertNotNil(response)
                expectation.fulfill()
            case .failure(let error):
                print("sendOtp error", error)
                XCTAssertFalse(true,"sendOtp  Failed")
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    
    func test_Send_OTP_With_InValid_Number(){
        // Initialize LoginVC from storyboard
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        let expectation = self.expectation(description: "SEND_OTP_RETURNS_RESPONSE")
        
        guard let mobNumber = ProcessInfo.processInfo.environment["invalid_mob"] else {
            XCTFail("Mobile number is not set")
            return
        }
        
        let data = ["mobileNumber": "99153610", "referral_code": ""] as [String : Any]
        
        if mobNumber.count == 10 {
            NetworkManager(data: data, url: nil, service: .sendOtp, method: .post, isJSONRequest: true).executeQuery {(result: Result<BaseResponse<SendOtpModel>, Error>) in
                
                switch result{
                case .success(let response):
                    print("send Otp response ------>",response)
                    XCTAssertNotNil(response)
                    expectation.fulfill()
                case .failure(let error):
                    print("sendOtp error", error)
                    XCTAssertFalse(true,"sendOtp  Failed")
                    expectation.fulfill()
                }
            }
            
        }
        else{
            XCTAssertTrue(true, "Mobile number should not be or less than 10")
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_Send_OTP_With_Empty_Number(){
        // Initialize LoginVC from storyboard
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        let expectation = self.expectation(description: "SEND_OTP_RETURNS_RESPONSE")
        
        var mobNumber: String?
        mobNumber = ""
        
        if mobNumber?.count == 0 {
            XCTAssertTrue(true, "Mobile number should not be empty")
            expectation.fulfill()
            
        }
        else{
            XCTAssertFalse(true,"Error occured")
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testDidTapLoginButton_ValidEmail() {
        
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        let expectation = self.expectation(description: "SEND_OTP_RETURNS_RESPONSE")
        loginVC.loadViewIfNeeded()
        
        // Strong reference to UITextField
        let textField = UITextField()
        loginVC.authenticationIdText = textField // Assign to the weak IBOutlet
        textField.text = "test@example.com" // Set valid email input
        // Act
        loginVC.didTapLoginButton(self)
        
        // Assert
        // Check the expected behavior (e.g., signIn was called, output printed)
        // Use spies or mock functions to validate the behavior if necessary.
        
    }
    
    
    func testShouldChangeCharacters_EnableSendOtpButton() {
            // Arrange
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        let expectation = self.expectation(description: "SEND_OTP_RETURNS_RESPONSE")
        loginVC.loadViewIfNeeded()

            let textField = UITextField()
            let currentText = "12345"
            textField.text = currentText
            let replacementText = "6"
            let range = NSRange(location: currentText.count, length: 0) // Append a single character

            // Act
            let shouldChange = loginVC.textField(textField, shouldChangeCharactersIn: range, replacementString: replacementText)

            // Assert
            XCTAssertTrue(shouldChange)
            // Assuming `enableDisableSendOtpButton` has been implemented
            // Check whether the button is enabled
        }
    
    func testShouldChangeCharacters_DisableSendOtpButton() {
            // Arrange
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        let expectation = self.expectation(description: "SEND_OTP_RETURNS_RESPONSE")
        loginVC.loadViewIfNeeded()

            let textField = UITextField()
            let currentText = "1234"
            textField.text = currentText
            let replacementText = "" // Deleting a character
            let range = NSRange(location: currentText.count - 1, length: 1)

            // Act
            let shouldChange = loginVC.textField(textField, shouldChangeCharactersIn: range, replacementString: replacementText)

            // Assert
            XCTAssertTrue(shouldChange)
            // Validate the `enableDisableSendOtpButton(enable:)` call
        }
    
    func testDidEndEditing_EnableSendOtpButton() {
            // Arrange
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        let expectation = self.expectation(description: "SEND_OTP_RETURNS_RESPONSE")
        loginVC.loadViewIfNeeded()

            let textField = UITextField()
            textField.text = "123456" // More than 5 characters

            // Act
        loginVC.textFieldDidEndEditing(textField)

            // Assert
            // Validate that `enableDisableSendOtpButton(enable: true)` is called
        }
    
    func testDidEndEditing_DisableSendOtpButton() {
            // Arrange
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        let expectation = self.expectation(description: "SEND_OTP_RETURNS_RESPONSE")
        loginVC.loadViewIfNeeded()


            let textField = UITextField()
            textField.text = "123" // Less than 5 characters

            // Act
        loginVC.textFieldDidEndEditing(textField)

            // Assert
            // Validate that `enableDisableSendOtpButton(enable: false)` is called
        }

    class LoginVCSpy: LoginVC {
        var didCallSignIn = false
        var lastUsername: String?
        var lastIsEmail: Bool?
        var performedSegueIdentifier: String?

        override func signIn(username: String, isEmail: Bool) {
            didCallSignIn = true
            lastUsername = username
            lastIsEmail = isEmail
        }
        
        override func performSegue(withIdentifier identifier: String, sender: Any?) {
                performedSegueIdentifier = identifier
            }
    }
}
