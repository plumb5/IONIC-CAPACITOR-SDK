//
//  P5ScreenFlow.swift
//  Plumb5SDK
//
//  Created by Shama on 5/14/17.
//  Copyright © 2017 Plumb5. All rights reserved.
//

import Foundation

class P5ScreenFlow {
    
    // MARK: - Attributes
    
    let extraParam: String
    let screenName: String
    
    // MARK: - Init
    
    init(object: ScreenFlow) {
        self.extraParam = object.extraParam!
        self.screenName = object.screenName!
    }
}
