//
//  P5CountDownView.swift
//  Plumb5SDK
//
//  Created by Shahid Akhtar Shaikh on 7/7/17.
//  Copyright © 2017 Plumb5. All rights reserved.
//

import UIKit

class P5CountDownView: UIView {
    @objc var model: NSDictionary = [:] {
        didSet {
            drawCountDownView()
        }
    }

    @objc let lable = UILabel()
    @objc var timer: Timer?

    @objc func drawCountDownView() {
        let Text = model.value(forKey: Constants.key_text) as! String
        lable.text = Text
        lable.numberOfLines = 0
        let Size = model.value(forKey: Constants.key_Size) as! String
        let Style = model.value(forKey: Constants.key_Style) as! String

        let Width = model.value(forKey: Constants.key_Width) as! String
        let Padding = convertPostions(position: model.value(forKey: Constants.key_Padding) as! String)
        let Color = model.value(forKey: Constants.key_Color) as! String
        let Orientation = model.value(forKey: Constants.key_Orientation) as! String
        lable.textColor = P5SDKManager.sharedInstance.hexStringToUIColor(hex: Color)

        Utility.setFontTo(view: lable, size: Size, style: Style, align: Orientation)

        Utility.setAutolayout(toView: lable, inView: self, attributes: Padding, fieldPosition: FieldPosition.None, topView: UIView(), topViewAttibutes: "", width: CGFloat((Width as NSString).doubleValue), alignment: "nil")
        updateCountDownTime()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountDownTime), userInfo: nil, repeats: true)
    }

    @objc func updateCountDownTime() {
        let Text = model.value(forKey: Constants.key_text) as! String

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let date = dateFormatter.date(from: Text)
        let interval = date?.timeIntervalSince(Date())
        let time = NSInteger(interval!)
        if time < 0 {
            lable.text = "00:00:00"
        } else {
            lable.text = stringFromTimeInterval(interval: interval!)
        }
    }

    @objc func stringFromTimeInterval(interval: TimeInterval) -> String {
        let ti = NSInteger(interval)

        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        var hours = (ti / 3600)
        let days = hours / 24
        hours = hours % 24
        if days > 1 {
            return NSString(format: "%d Days %0.2d:%0.2d:%0.2d", days, hours, minutes, seconds) as String
        } else if days == 1 {
            return NSString(format: "1 Day %0.2d:%0.2d:%0.2d", hours, minutes, seconds) as String
        } else {
            return NSString(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds) as String
        }
    }

    @objc public func viewRemoved() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
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
