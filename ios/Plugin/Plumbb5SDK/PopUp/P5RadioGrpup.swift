//
//  P5RadioGrpup.swift
//  Plumb5SDK
//
//  Created by Shahid Akhtar Shaikh on 6/19/17.
//  Copyright © 2017 Plumb5. All rights reserved.
//

import UIKit

class P5RadioGrpup: P5BaseFromView {
    @objc var selectItem: String?
    @objc var model: NSDictionary = [:] {
        didSet {
            drawRadioGroup()
        }
    }

    @objc func drawRadioGroup() {
        let Text = model.value(forKey: Constants.key_text) as! String
        let Size = model.value(forKey: Constants.key_Size) as! String
        let Style = model.value(forKey: Constants.key_Style) as! String

        let Width = model.value(forKey: Constants.key_Width) as! String
        let Padding = convertPostions(position: model.value(forKey: Constants.key_Padding) as! String)
//        let Align = model.value(forKey: Constants.key_Align) as! String
        let Color = model.value(forKey: Constants.key_Color) as! String
        let Orientation = model.value(forKey: Constants.key_Orientation) as! String
        let fields = Text.components(separatedBy: ",")
        for index in 0 ... fields.count - 1 {
            let field = fields[index]
            print("Radio btn: " + field)
            let fieldPosition = Utility.getHorizontalFieldPosition(index: index, totalCount: fields.count)
            let topView: UIView?
            if index == 0 {
                topView = UIView()
            } else {
                topView = subviews[index - 1]
            }
            let btn = P5RadioButton()
            btn.configureButton()
            btn.setTitleColor(P5SDKManager.sharedInstance.hexStringToUIColor(hex: Color), for: .normal)
            btn.tag = index
            btn.addTarget(self, action: #selector(radioBtnTapped), for: .touchUpInside)
            btn.setTitle(field, for: .normal)
            Utility.setFontTo(view: btn, size: Size, style: Style, align: Orientation)
            Utility.setAutolayout(toView: btn, inView: self, attributes: Padding, fieldPosition: fieldPosition, topView: topView!, topViewAttibutes: "", width: CGFloat((Width as NSString).doubleValue) / CGFloat(fields.count), alignment: "")
            btn.setTitleColor(P5SDKManager.sharedInstance.hexStringToUIColor(hex: Color), for: .normal)
        }
    }

    @objc func radioBtnTapped(btn: UIButton) {
        let tag = btn.tag
        selectItem = btn.titleLabel?.text
        for index in 0 ... subviews.count - 1 {
            let view = subviews[index]
            if view is P5RadioButton {
                let btn = view as! P5RadioButton
                if tag == view.tag {
                    btn.isSelected = true
                } else {
                    btn.isSelected = false
                }
            }
        }
    }

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

    @objc func convertPostions(position: String) -> String {
//        var newPostion : String
//        let array = position.components(separatedBy: ",")
//        if array.count == 4 {
//            newPostion = array[1] + "," + array[2] + "," + array[3] + "," + array[0]
//        }else{
//            newPostion = position
//        }
        return position
    }
}
