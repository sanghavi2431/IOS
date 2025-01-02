//
//  Constants.swift
//  WSTagsField
//
//  Created by Ilya Seliverstov on 11/07/2017.
//  Copyright © 2017 Whitesmith. All rights reserved.
//

import UIKit

enum IAPProduct: String {
    //in.woloo.app.onemonth
    //case oneMonthSubscription = "in.woloo.app.subscription.onemonth
    case oneMonthSubscription = "in.woloo.app.onemonth"
}

internal struct Constants {
    internal static let TEXT_FIELD_HSPACE: CGFloat = 6.0
    internal static let MINIMUM_TEXTFIELD_WIDTH: CGFloat = 56.0
    internal static let STANDARD_ROW_HEIGHT: CGFloat = 25.0
}

struct Segues {
    static let editProfile = "EditProfileSegue"
    static let searchLocation = "SearchLocationSegue"
    static let qRCodeScan = "QRCodeScanSegue"
    static let storeDetail = "DetailVCSegue"
    static let reviewDetailSegue = "ReviewDetail"
    static let subscriptionVC = "SubscriptionVC"
    static let enrouteVC = "EnrouteVC"
    static let searchWolooVC = "SearchWolooVC"
}

struct Key {
    static let name = "name"
    static let email = "email"
    static let city = "city"
    static let pincode = "pincode"
    static let address = "address"
}

struct Cell {
    static let searchLocation = "SearchLocationCell"
    static let searchStore = "SearchStoreCell"
    static let referHostCell = "ReferHostCell"
    static let bannerCollectionCell = "BannerCollectionCell"
    static let bannerListCell = "BannerListCell"
    static let dashBoardLocationCell = "DashBoardLocationCell"
    static let dashBoardProfileCell = "DashBoardProfileCell"
    static let trendingListCell = "TrendingListCell"
    static let blogDetailCell = "BlogDetailCell"
    static let introCell = "IntroCell"
    static let logDetailCell = "LogDetailCell"
    static let dailyLogCell = "DailyLogCell"
    static let articleListCell = "ArticleListCell"
    static let periodCalenderCell = "PeriodCalenderCell"
    static let trackeLogListCell = "TrackeLogListCell"
    static let trackerLogDetailCell = "TrackerLogDetailCell"
    static let offerWolooCell = "OfferWolooCell"
    static let myOfferWolooCell = "HistoryCell"
}

struct Text {
    static let scanQr = "Scan QR Code"
}
