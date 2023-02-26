//
//  P5RadioButton.swift
//  Plumb5SDK
//
//  Created by Shahid Akhtar Shaikh on 6/19/17.
//  Copyright © 2017 Plumb5. All rights reserved.
//

import UIKit

class P5RadioButton: UIButton {
    @objc func configureButton(){
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right:0)
        self.contentHorizontalAlignment = .left
        let frameWorkBundle = Bundle(for: type(of: self))
        let imgChecked = UIImage.init(named: "ic_radio_selected", in: frameWorkBundle, compatibleWith: nil);
        let imgUnChecked = UIImage.init(named: "ic_radio_unselected", in: frameWorkBundle, compatibleWith: nil);
        self.setImage(imgChecked, for: .selected)
        self.setImage(imgUnChecked, for: .normal)
    }
}
