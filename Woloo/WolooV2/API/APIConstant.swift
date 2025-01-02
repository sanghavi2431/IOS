//
//  APIConstant.swift
//  Sawin
//
//
//

import UIKit

class APIConstantV2: NSObject {

}

//Staging: https://staging-api.woloo.in
//Prod: https://api.woloo.in
//local: http://localhost:4000/api/

var HTTP_BASE_URL = "https://api.woloo.in"



var BASE_URL = "\(HTTP_BASE_URL)"
var BASE_CENTRAL_URL = "\(HTTP_BASE_URL)"
var APP_VERSIONV2 = Utility.getAppversion()

func SSLog(message: Any?) {
    #if DEBUG
    print("%@",message ?? "")
    #endif
}


