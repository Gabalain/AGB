//
//  AppDelegate.swift
//  AGB
//
//  Created by Alain Gabellier on 10/09/2018.
//  Copyright © 2018 Alain Gabellier. All rights reserved.
//

import UIKit
import BMSCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let myBMSClient = BMSClient.sharedInstance
        myBMSClient.initialize(bluemixRegion: BMSClient.Region.germany)
        //    myBMSClient.initialize(bluemixRegion: BMSClient.Region.unitedKingdom)
        myBMSClient.requestTimeout = 10.0 // seconds
        
        
        return true
    }

}

