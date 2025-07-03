//
//  StringConstants.swift
//  YesFlix
//
//  Created by Ashish.Khobragade on 31/10/18.
//  Copyright © 2018 Ashish.Khobragade. All rights reserved.

import UIKit

class StringConstants: NSObject {

   // MARK:-  Strings
    
//    static let serverErrorMessageValue = "serverErrorMessageValue"
    static let networkMessage = "networkMessage"
    static let retryMessage = "retryMessage"
    static let networkMessageTV = "networkMessageTV"

    // MARK:-  API Strings
    
    static let serverErrorType = "serverErrorType"
    static let serverErrorTypeValue = "serverErrorTypeValue"
    static let serverErrorMessage = "serverErrorMessage"
    
    static let passowrdInstruction = "passowrdInstruction"
    static let emailAndConfirmEmailMismatch = "emailAndConfirmEmailMismatch"
    static let enterFullnameNotEmpty = "enterFullnameNotEmpty"
    static let emailShouldNotBlack = "emailShouldNotBlack"
    static let confirmEmailShouldNotBlank = "confirmEmailShouldNotBlank"
    static let validMobileNumber = "validMobileNumber"
    static let enterMobileNotEmpty = "enterMobileNotEmpty"
    
    static let otpShouldNotBlank = "otpShouldNotBlank"
    static let verificationCodeShouldNotBlank = "verificationCodeShouldNotBlank"
    static let profileNameShouldNotBlank = "profileNameShouldNotBlank"
    static let validEmailIdMessage = "validEmailIdMessage"
    static let emailIdLengthMessage = "emailIdLengthMessage"
    static let characterLimitMessage = "characterLimitMessage"
    static let commentMessage = "commentMessage"
    static let reportMessage = "reportMessage"
    static let emptyCommentMessage = "emptyCommentMessage"
    static let commentValidationMessage = "err_comment_enter"
    static let shareMessage = "shareMessage"
    static let shareURL = "shareURL"
    static let nonSubscribedUSerMessage = "nonSubscribedUSerMessage"
    static let do_you_want_delete_device = "do_you_want_delete_device"
    static let do_you_want_delete_all_device = "do_you_want_delete_all_device"
    static let deviceListMessage = "deviceListMessage"
    static let addDeviceMessage_part_1 =  "addDeviceMessage_part_1"
    static let addDeviceMessage_part_2 =  "addDeviceMessage_part_2"
    static let noActiveSubscriptionMessage =  "noActiveSubscriptionMessage"
    static let noDataAvailableMessage =  "noDataAvailableMessage"
    static let subscriptionPlan =  "subscriptionPlan"
    static let autorenewal = "autorenewal"
    static let subscribedOn = "subscribedOn"
    static let expiresOn = "expiresOn"
    static let subscriptionBenefits = "subscriptionBenefits"
    static let blockBanTitle = "blockBanTitle"
    static let removeFromFavorites = "remove"
    static let lbl_watchlist = "lbl_watchlist"
    static let back = "back"
    static let enterCommentText = "enterCommentText"
    static let noCommentText = "noCommentText"
    
    static let directorText = "directorText"
    static let enterMessage = "enterMessage"


    static let youMayLikeLbl = "youMayLikeLbl"
    static let playLabel = "playLabel"
    static let censorRatingBefore = "censorRatingBefore"
    static let censorRatingAfter = "censorRatingAfter"

     static let searchScope_1 = "searchScope_1"
     static let searchScope_2 = "searchScope_2"
    
    
    static let minimumUserNameCharacterLimit = 2
    static let maximumUserNameCharacterLimit = 30
    
    static let minimumCharacterLimit = 10
    static let maximumCharacterLimit = 500

    static let submit = "submit"
    static let cancel = "cancel"
    static let warning = "warning"
    static let alertTitle = "alertTitle"
    static let dashboardAlertTitle = "dashboardAlertTitle"
    static let camera = "camera"
    static let source =  "source"
    static let gallery =  "gallery"
    static let searchMaxChar = "searchMaxChar"
    static let remove = "remove"
    static let done = "done"
    static let signOut = "signOut"
    static let Add = "Add"
    static let addDeviceTitle = "addDeviceTitle"
    static let addDeviceMessageDescription = "addDeviceMessageDescription"
    static let nowPlaying = "nowPlaying"
    static let shareTitle = "shareTitle"
    static let commentTitle = "commentTitle"
    static let voucherCode = "voucherCode"
    static let verificationCode = "verificationCode"
    static let voucherCodeMessage =  "voucherCodeMessage"
    static let unlock = "unlock"
    static let verificationLink = "verificationLink"

    static let listOfDevice = "listOfDevice"
    static let signout = "sign_out"
    static let accountVerification = "accountVerification"
    static let sendVerificationCodeLabel = "sendVerificationCodeLabel"
    static let sendVerificationCodeLabel2 = "sendVerificationCodeLabel2"
    static let removeAll = "removeAll"
    static let confirm = "confirm"
    static let success = "success"
    
    static let german = "german"
    static let english = "english"
    static let danish = "danish"
    static let seeAll      = "seeAll"
    
    // MARK:-  Login Screen
    
    static let loginHeaderText = "loginHeaderText"
    static let registerWithFacebook = "registerWithFacebook"
    static let continueWithFacebook = "continueWithFacebook"
    static let logoutWithFacebook = "logoutWithFacebook"
    static let OR = "OR"
    static let placeHolderSearch = "placeHolderSearch"
    static let placeHolderEmail = "placeHolderEmail"
    static let placeHolderConfirmEmail = "placeHolderConfirmEmail"
    static let placeHolderFullName = "placeHolderFullName"
    static let placeHolderUsername = "placeHolderUsername"
    static let placeHolderAge = "placeHolderAge"

    static let thisDevice = "thisDevice"
    
    static let loginButtonTitle = "loginButtonTitle"
    static let termsPolicyPrivacy = "termsPolicyPrivacy"
    static let termsofService = "termsofService"
    static let privacyPolicy = "privacyPolicy"
    static let perosnalData = "perosnalData"
    static let otpInstruction = "otpInstruction"
    static let registerAccount = "registerAccount"
    static let register = "register"
    static let save = "save"
     static let profileDetails = "profileDetails"
    static let  createProfile = "createProfile"
    static let backToLogin = "backToLogin"
    static let acceptanceTermsPolicy = "acceptanceTermsPolicy"
    static let resendCode = "resendCode"
    static let changeEmail = "changeEmail"
        
    // MARK:-  Edit Profile  Screen
    static let headerEditProfile = "headerEditProfile"
    static let placeHolderProfileName = "placeHolderProfileName"
    
    
    // MARK:- Contact Us Screen
    static let ContactUsHeaderText = "ContactUsHeaderText"
    static let headerFeedbackText = "headerFeedbackText"
    static let emailIDText = "emailIDText"
    static let dontForgetText = "dontForgetText"
    static let NameText = "NameText"
    static let EmailAddressText = "EmailAddressText"
    static let QueryText = "QueryText"
    static let MessageText = "MessageText"

    
    //     Payment History"
    static let paymentHistory = "paymentHistory"
    static let paymentStatusSuccess = "paymentStatusSuccess"
    static let paymentStatusFail = "paymentStatusFail"
    static let orderNumber = "orderNumber"
    static let orderPlaced = "orderPlaced"
    static let paymentStatus = "paymentStatus"
    static let totalPayment = "totalPayment"
    static let paidBy = "paidBy"
    
    //    Rent or Buy alert
    static let rent = "rent"
    static let buy = "buy"
    static let rentalExpiredInText = "rentalExpiredInText"
    static let rentalExpiredInText_2 = "rentalExpiredInText_2"
    static let expiredText = "expiredText"
    static let txtfor = "txtfor"
    
    // Personal Data Content
    
    static let personalDataTitleText = "personalDataTitleText"
    static let personalDataEmailText = "personalDataEmailText"
    static let personalDataNameText = "personalDataNameText"
    static let personalDataDOBText = "personalDataDOBText"
    static let personalDataIPAddressText = "personalDataIPAddressText"
    static let personalDataLocationText = "personalDataLocationText"
    static let personalDataManagingText = "personalDataManagingText"
    static let personalDataServingText = "personalDataServingText"
    
    //Registratrion View alert
    static let regFullNameMsg = "regFullNameMsg"
    static let regFullNotBlakMsg = "regFullNotBlakMsg"
    static let regUserNameMsg = "regUserNameMsg"
    static let regUserNameMsgMinimumChar = "regUserNameMsgMinimumChar"
    static let regUserAge = "regUserAge"
    static let regUserNameLengthMsg = "regUserNameLengthMsg"
    
    
    //WatchList string
    
    static let addToWatchListText = "addToWatchListText"
    static let removeFromWatchListText = "removeFromWatchListText"
    
    //Rating View
    static let rateThisMovie = "rateThisMovie"
    static let yourRating = "yourRating"
    static let rateText = "rateText"

    static let genre = "genre"
    static let subtitles = "subtitles"
    static let audio = "audio"
    static let video = "video"
    static let off = "off"
    
    
    //Amzad download Module Strings
    //---------Download Module Strings Starts -----------------
    
    static let downloadedMovies =  "downloadedMovies" //Downloaded movies
    static let downloadActions =  "downloadActions" //Download Actions
    static let wantToDelete =  "msgDownloadDelete" //Are you sure you want to delete?
    static let wantToCancel =  "wantToCancel" //Are you sure you want to cancel?
    static let resumeDownload =  "resumeDownload" //Resume Download
    static let cancelDownload =  "cancelDownload" //Cancel Download
    static let pauseDownload =  "pauseDownload" //Pause Download
    
    
    static let paused =  "paused" //Pause
    static let downloading =  "downloading" //Downloading
    static let download =  "download" //Download
    static let downloaded =  "downloaded" //Downloaded
    static let queued     = "queued" //Queued
    
    
    
    static let alertCancel =  "cancel" //Cancel
    static let alertYes =  "alertYes" //Yes
    static let alertNo =  "alertNo" //No
    static let alertConfirm =  "alertConfirm" //Confirm
    
    static let deleteAllMovies =  "deleteAllMovies" //All your downloaded movies will be deleted
    
    static let hrLeft      = "hrLeft"
    static let minLeft      = "minLeft"
    
    static let hr      = "hr"
    static let min      = "min"
    
    static let delete       = "remove"
    
    static let select       = "select"
    
    static let switchOnline = "onlineMessage"
    
    static let alertAnother = "alertAnother"
    static let alertAnother2 = "alertAnother2"
    
    static let alertAnotherTitle = "alertAnotherTitle"
    static let alertMovieDownloaded = "alertMovieDownloaded"
    
    
    static let alertStorageTitle = "alertStorageTitle"
    static let alertStorageMessage = "alertStorageMessage"
    static let alertSettings       = "alertSettings"

    
    //------- Download Module Strings Ended ---- Amzad

    static let rentBtnText            = "rentBtnText"
    static let buyBtnText             = "buyBtnText"
    static let free             = "free"
    static let allBundlePurchaseText             = "allBundlePurchaseText"
    static let noPurchaseMessage             = "noPurchaseMessage"

    static let rentBundleBtnText      = "rentBundleBtnText"
    static let buyBundleBtnText       = "buyBundleBtnText"
    static let bundleBuyPopUptext     = "bundleBuyPopUptext"
    static let purchaseBundle         = "purchaseBundle"
    static let purchaseSingle         = "purchaseSingle"
    static let mediaNotAvailable      = "mediaNotAvailable" //Media not available
    
    
    static let tabDashboard           = "Home"
    static let tabMovies              = "Movies"
    static let tabSeries              = "Series"
    static let tabFavourite           = "Favourite"
    static let tabSettings            = "Settings"
    static let tabSearch              = "Search"
    
    
   
    static let Watchlist_Layout           = "Watchlist_Layout"
    static let Downloaded_Movies_Layout              = "Downloaded_Movies_Layout"
    static let Download_Quality_Layout              = "Download_Quality_Layout"
    static let FAQ_Layout              = "FAQ_Layout"
    static let Refund_Policy_Layout            = "Refund_Policy_Layout"
    static let about_us              = "about_us"
    static let profile           = "profile"
    static let language              = "language"
    static let device_management              = "device_management"
    static let transaction_history              = "transaction_history"
    static let contact_us            = "contact_us"
    static let logout              = "logout"
    static let my_account              = "my_account"
    
}

//One or more of the titles in this bundle are already in your Library. Do you wish to proceed?


extension String {
    
    var encodeEmoji: String? {
        
        let encodedStr = NSString(cString: self.cString(using: String.Encoding.nonLossyASCII)!, encoding: String.Encoding.utf8.rawValue)
        return encodedStr as String? //CMS
    }
    
    func replaceMatches(pattern: String, inString string: String, withString replacementString: String) -> String? {
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSMakeRange(0, string.count)
        return regex.stringByReplacingMatches(in: string, options: [], range: range, withTemplate: replacementString)
    }
    
    var decodeEmoji: String {
        
        var newString =  replaceMatches(pattern: "(\\\\\\\")", inString: self, withString: "\"")!
        newString =  replaceMatches(pattern: "(\\\\/)", inString: newString, withString: "/")!
        newString =  newString.replacingOccurrences(of: "\\n", with: "\n")
        let data = newString.data(using: String.Encoding.utf8, allowLossyConversion: false)
        if data != nil {
            let valueUniCode = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue) as String? //CMS
            if valueUniCode != nil {
                return valueUniCode!
            } else {
                return self
            }
        } else {
            return self
        }
    }
}



extension StringConstants {
    
    static let you_can_add_maximum_of = "you_can_add_maximum_of"
    static let devices_Please_remove_one_from_below_list = "devices_Please_remove_one_from_below_list"
    static let linked_on = "linked_on"
    static let sign_out = "sign_out"
    static let see_all = "see_all"
    static let search_hint = "search_hint"
    static let recommended_movies = "recommended_movies"
    static let categories = "categories"
    static let choose_categories = "choose_categories"
    static let my_feeds = "my_feeds"
    static let edit = "edit"
    static let my_watch_list = "my_watch_list"
    static let download_videos = "Downloaded_Movies_Layout"
    static let download_quality = "download_quality"
    static let help_faq = "help_faq"
    static let cancellation_policy = "cancellation_policy"
    static let version = "version"
    static let no_download_available = "no_download_available"
    static let loading_online_version = "loading_online_version"
    static let play = "play"
    static let pause = "pause"
    static let not_downloaded = "not_downloaded"
    static let failed = "failed"
    static let best = "best"
    static let better = "better"
    static let good = "good"
    static let download_quality_title = "download_quality_title"
    static let preference_best = "preference_best"
    static let preference_better = "preference_better"
    static let preference_good = "preference_good"
    static let preference_best_quality_desc = "preference_best_quality_desc"
    static let preference_better_quality_desc = "preference_better_quality_desc"
    static let preference_good_quality_desc = "preference_good_quality_desc"
    static let delete_all = "delete_all"
    static let order_number = "order_number"
    static let rental_includes = "rental_includes"
    static let order_placed = "order_placed"
    static let total_payment = "total_payment"
    static let type = "type"
    static let paid_by = "paid_by"
    static let payment_status = "payment_status"
    static let rented = "rented"
    static let successful = "successful"
    static let okay = "okay"
    static let query_type_ = "query_type_"
    static let full_name_ = "full_name_"
    static let email_address_ = "email_address_"
    static let message_ = "message_"
    static let min_max_msg_limit_thousand = "min_max_msg_limit_thousand"
    static let please_user_name_len = "please_user_name_len"
    static let please_enter_valid_user_name = "please_enter_valid_user_name"
    static let left = "left"
    static let rent_hd = "rent_hd"
    static let rent_free = "rent_free"
    static let buy_free = "buy_free"
    static let play_trailer = "play_trailer"
    static let no_trailer = "no_trailer"
    static let purchase_unavailable = "purchase_unavailable"
    static let cast = "cast"
    static let director = "director"
    static let sub_title = "sub_title"

    static let your_rating = "your_rating"
    static let your_rating_end_msg = "your_rating_end_msg"
    static let add_fav = "add_fav"
    static let rate = "rate"
    static let rate_movie = "rate_movie"
    static let comment = "comment"
    static let payment = "payment"
    static let posted_on = "posted_on"
    static let report = "report"
    static let report_message = "report_message"

    static let remove_message = "remove_message"
    static let write_a_comment = "write_a_comment"
    static let err_comment_enter = "err_comment_enter"
    static let share_title = "share_title"
    static let loading = "loading"
    static let member_id_validation = "member_id_validation"
    static let search_limit_char = "search_limit_char"
    static let profile_name_error_msg = "profile_name_error_msg"
    static let profile_msg = "profile_msg"
    static let email_id = "email_id"
    static let country = "country"
    static let date_of_birth = "date_of_birth"
    static let membership_id = "membership_id"
    static let your_details_are_provided_by = "your_details_are_provided_by"
    static let Contact = "Contact"
    static let to_update_your_details = "to_update_your_details"
    static let subscription_access = "subscription_access"
    static let related_news = "related_news"
    static let read_more = "read_more"
    static let share = "share"
    static let offers_of_the_week = "offers_of_the_week"
    static let offer_claimed = "offer_claimed"
    static let we_have_sent_coupon = "we_have_sent_coupon"
    static let claim = "claim"
    static let more_info = "more_info"
    
    static let slow_internet_connection = "slow_internet_connection"
    static let internet_connection_not_available = "internet_connection_not_available"
    static let exit_app_title = "exit_app_title"
    static let exit_app_button_title = "exit_app_button_title"
    static let update_text = "update_text"
    static let update_available = "update_available"
    static let not_now = "not_now"
    static let update = "update"
    static let exit = "exit"
    static let update_now = "update_now"
    static let msg_update_movie = "msg_update_movie"
    static let list_of_device = "list_of_device"
    static let add = "add"
    static let add_device = "add_device"
    static let add_this_device_in_your_profile = "add_this_device_in_your_profile"
    static let do_you_want_log_out = "do_you_want_log_out"
    static let something_went_wrong = "something_went_wrong"
    static let reviews = "reviews"
    static let welcome = "welcome"
    static let error_fragment_message = "error_fragment_message"
    static let dismiss_error = "dismiss_error"
    static let search_result = "search_result"
    static let search_not_result_found = "search_not_result_found"
    static let no_data_avl = "no_data_avl"
    static let no_search_result = "no_search_result"
    static let no_search_result_for = "no_search_result_for"
    static let search_result_for = "search_result_for"
    static let resume = "resume"
    static let start_over = "start_over"
    static let slow_internet_connection_ = "slow_internet_connection_"
    static let no_internet_connection_ = "no_internet_connection_"
    static let server_not_connected = "server_not_connected"
    static let tap_to_retry = "tap_to_retry"
    static let retry = "retry"
    static let error_vpn_message = "error_vpn_message"
    static let min_max_msg_limit = "min_max_msg_limit"
    static let select_picture = "select_picture"
    static let permission_deny = "permission_deny"
    static let permission_never_ask = "permission_never_ask"
    static let select_preferred_lang = "select_your_prefer_lang_"
    static let feeds = "feeds"
    static let follow = "follow"
    static let unfollow = "unfollow"
    static let like = "like"
    static let likes = "Likes"
    static let users_following = "users_following"
    static let change_photo = "change_photo"
    static let no_watchlist = "no_watchlist"
    static let premium = "premium"
    
    
    static let myWatchList = "myWatchList"
    
    
    static let quality = "quality"
    static let msgNoInternet = "msgNoInternet"
    static let loadOfflineMode = "loadOfflineMode"
    static let msgLoadOnline = "msgLoadOnline"
    static let onlineMessage = "onlineMessage"

    static let playerVideo = "playerVideo"
    static let playerAudio = "playerAudio"
    static let playerSubtitle = "playerSubtitle"
    static let lbl_download_videos = "lbl_download_videos"
    static let devices_management = "devices_management"

    static let msgOfferClaim    = "msgOfferClaim"
    static let titleOfferClaim  = "titleOfferClaim"
    static let footerOfferClaim = "footerOfferClaim"


    static let linkedOn         = "linkedOn"

    static let paymeantStatus   = "paymeantStatus"
    
    static let noDataAvailable  = "noDataAvailable"
    

    static let lbl_rent = "rent"
    
    static let rated = "rated"
    static let comments = "comment"

    static let currently = "currently"
    static let msgDownloading = "msgDownloading"
    static let msgDownloadCancel = "msgDownloadCancel"
    static let msgDownloadDelete = "msgDownloadDelete"
    static let confirmation = "confirmation"
    static let msgDataNetwork = "msgDataNetwork"
    static let msgAlreadyRated = "msgAlreadyRated"
    static let msgRateWatch = "msgRateWatch"
    static let msgRatePurchase = "msgRatePurchase"
    static let postedOn = "postedOn"
    
    static let writeComment = "writeComment"
    static let writeReview = "writeReview"
    
    static let msgLogOutDeleteAll = "msgLogOutDeleteAll"
    static let editProfile = "editProfile"
    static let msgProfileHeader = "msgProfileHeader"
    static let msgProfileFooter = "msgProfileFooter"
    static let msgProfileValidation = "msgProfileValidation"
    static let profile_footer_next = "profile_footer_next"
    static let your_details_ = "your_details_are_provided_by"
    static let contact_ = "Contact"
    static let to_update_details_ = "to_update_your_details"
    static let fullName = "fullName"
    static let email = "email"
    static let dob = "dob"
    static let membershipID = "membershipID"
    static let moviLinkNotAvailable = "moviLinkNotAvailable"
    
    static let msgQueueItem = "msgQueueItem"
    static let msgWaitingInternet = "msgWaitingInternet"
    static let msgSpaceNotAvailable = "msgSpaceNotAvailable"
    static let expireIn = "expireIn"
    
    static let boughtText = "boughtText"
    static let rentalText = "rentalText"
    static let msgBought = "msgBought"
        
    
    static let textSearchResult = "textSearchResult"
    static let textRecomdMovies = "textRecomdMovies"
    static let textExpireLeft = "textExpireLeft"
    static let textRentAlertBack = "textRentAlertBack"
    static let msgAlertRentMovie = "msgAlertRentMovie"
    static let textWishToRent    = "textWishToRent"
    static let checkSpace = "checkSpace"
    
    static let msgTitleCameraAccess = "msgTitleCameraAccess"
    static let msgCameraAccess  = "msgCameraAccess"
    static let changePhoto      = "changePhoto"
    
    static let select_your_prefer_lang_ = "select_your_prefer_lang_"
    
    static let watch_trailer        = "watch_trailer"
    static let lbl_play             = "play"
    static let msgDeleteDownloaded  = "msgDeleteDownloaded"
    static let lbl_device_max       = "lbl_device_max"
    static let recommendations = "recommendations"
    
    
    static let lang_app = "lang_app"    
    static let lang_audio = "lang_audio"
    static let lang_subtitle = "lang_subtitle"
    static let none_subtitle = "none_subtitle"
    static let none_audio = "none_audio"
    static let lang_note = "lang_note"
    static let lang_pref_save = "lang_pref_save"
}
