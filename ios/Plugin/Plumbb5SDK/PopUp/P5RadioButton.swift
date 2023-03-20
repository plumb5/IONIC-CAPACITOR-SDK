//
//  P5RadioButton.swift
//  Plumb5SDK
//
//  Created by Shahid Akhtar Shaikh on 6/19/17.
//  Copyright © 2017 Plumb5. All rights reserved.
//

import UIKit

class P5RadioButton: UIButton {
    @objc func configureButton() {
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        contentHorizontalAlignment = .left
//        self.backgroundColor = .black
        let frameWorkBundle = Bundle(for: type(of: self))
        let imgChecked = UIImage(named: "ic_radio_selected")
        let imgUnChecked = UIImage(named: "ic_radio_unselected")
        setImage(imgChecked, for: .selected)
        setImage(imgUnChecked, for: .normal)
    }
}
