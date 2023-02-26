//
//  P5NotificationUserInfo.swift
//  Plumb5SDK
//
//  Created by Shahid Akhtar Shaikh on 7/21/17.
//  Copyright © 2017 Plumb5. All rights reserved.
//

import Foundation

class P5NotificationUserInfo : NSObject{
    @objc var aps : Dictionary <String, Any>?
    @objc var mediaType : String?
    @objc var attachmentUrl : String?
    @objc var regions : Array<Dictionary<String , Any>>?
}
