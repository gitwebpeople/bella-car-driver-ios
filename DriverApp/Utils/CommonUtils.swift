//
//  CommonUtils.swift
//  Login_SignUp
//
//  Created by Chirag on 08/12/15.
//  Copyright © 2015 ESW. All rights reserved.
//

import UIKit

class CommonUtils {
    
    static let appleAppId = "1470954327"
    
    static let webServer: String = "https://www.meuvupt.com.br/"
    static var webservice_path: String = webServer+"webservice_shark.php";
   
    static let google_geoCode_url: String = "https://maps.googleapis.com/maps/api/geocode/json"
    static let google_direction_url: String = "https://maps.googleapis.com/maps/api/directions/json"
    static let linkedin_url: String = "\(webServer)linkedin-login/linkedin-app.php"
    static let app_user_name = "Driver"
    
    static let user_image_url = webServer + "webimages/upload/Driver/"
    static let passenger_image_url = webServer + "webimages/upload/Passenger/"
    static let restauarant_image_url = webServer + "webimages/upload/Company/"
    
    static let PAYMENTLINK =  webServer+"assets/libraries/webview/payment_configuration_trip.php?";
}
