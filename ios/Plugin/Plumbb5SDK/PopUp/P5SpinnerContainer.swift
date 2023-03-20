//
//  P5SpinnerContainer.swift
//  Plumb5SDK
//
//  Created by Shahid Akhtar Shaikh on 3/23/18.
//  Copyright © 2018 Plumb5. All rights reserved.
//

import UIKit

class P5SpinnerContainer: P5BaseFromView {
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
         // Drawing code
     }
     */

    @objc var selectItem: String?

    override func isFieldValid() -> Bool {
        if selectItem != nil {
            return true
        } else {
            return false
        }
    }

    override func fieldValue() -> String {
        return selectItem!
    }
}
