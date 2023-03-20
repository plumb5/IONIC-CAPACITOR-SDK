//
//  P5ExtraButton.swift
//  Plumb5SDK
//
//  Created by Shahid Akhtar Shaikh on 8/28/17.
//  Copyright © 2017 Plumb5. All rights reserved.
//

import Foundation
import UIKit

class P5ExtraButton: UIView {
    @objc var btnTapHandler: ((String, String) -> Void)?
    @objc var btnName: String?
    @objc var useIcon: String?
    @objc var btnIconId: String?
    @objc var param = ""
    @objc var btnPrams: String = "" {
        didSet {
            refreshUI()
        }
    }

    @objc func refreshUI() {
        let btn = UIButton(type: .custom)
        let btnParts = btnPrams.components(separatedBy: "^")
        btnName = btnParts[0]
        useIcon = btnParts[1]
        btnIconId = btnParts[2]
        if btnParts.count > 3 {
            param = btnParts[3]
        }
        let frameWorkBundle = Bundle(for: type(of: self))
        if useIcon == "1" {
            let imgClose = UIImage(named: btnIconId!)
            btn.setImage(imgClose, for: .normal)
        }
        btn.setTitle(btnName, for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        btn.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)

        Utility.setAutolayout(toView: btn, inView: self, attributes: "0,0,0,0", fieldPosition: FieldPosition.None, topView: UIView(), topViewAttibutes: "", width: 0, alignment: "nil")
        addHeightContraint(toView: btn, height: 50)
    }

    @objc func addHeightContraint(toView: UIView, height: CGFloat) {
        let metrics = ["height": height]
        let views: [String: Any] = ["toView": toView]
        let heightConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:[toView(height)]", options: [], metrics: metrics, views: views)

        NSLayoutConstraint.activate(heightConstraint)
    }

    @objc func btnTapped() {
        print("btn tapped")
        if btnTapHandler != nil {
            btnTapHandler!(btnIconId!, param)
        }
    }
}
