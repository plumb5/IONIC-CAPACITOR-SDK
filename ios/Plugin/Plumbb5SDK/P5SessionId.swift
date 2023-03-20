//
//  P5SessionId.swift
//  Plumb5SDK
//
//  Created by Shama on 5/11/17.
//  Copyright © 2017 Plumb5. All rights reserved.
//

import Foundation
class P5SessionId {
    static let sharedInstance = P5SessionId()
    // static var preTime:Int = 0
    static var p5Session: String = ""

    static var sessionId: Int64 = 0

    func getCurrentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let result = formatter.string(from: date)

        return result
    }

    func getCurrentMillis() -> Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }

    func getSessionId() -> String {
        let miliSeconds = getCurrentMillis()
        let diff = miliSeconds - P5SessionId.sessionId
        if P5SessionId.sessionId == 0 || diff > 300_000 {
            P5SessionId.sessionId = miliSeconds
            print("Diff : \(diff)")
        }

        P5SessionId.p5Session = "\(P5SessionId.sessionId)"
        print("p5Session : \(P5SessionId.p5Session)")
        return P5SessionId.p5Session
    }

    // Declare an initializer
    // Because this class is singleton only one instance of this class can be created
    private init() {
        print("P5DeviceInfo has been initialized")
    }
}
