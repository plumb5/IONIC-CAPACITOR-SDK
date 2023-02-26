//
//  P5ButtonView.swift
//  Plumb5SDK
//
//  Created by Shahid Akhtar Shaikh on 7/8/17.
//  Copyright © 2017 Plumb5. All rights reserved.
//

import UIKit

class P5ButtonView: UIView {
    @objc var btnTapHandler: ((Int,NSDictionary) -> Void)?
    @objc var model:NSDictionary = [:]{
        didSet{
            drawButton()
        }
    }
    @objc func drawButton(){
        clipsToBounds = true
        let btn = UIButton.init(type: .custom)
        let Text =  model.value(forKey: Constants.key_text) as! String
        let Size = model.value(forKey: Constants.key_Size) as! String
        let Style = model.value(forKey: Constants.key_Style) as! String
        
        let Width = model.value(forKey: Constants.key_Width) as! String
        let Padding = convertPostions(position:model.value(forKey: Constants.key_Margin) as! String)
        let Color = model.value(forKey: Constants.key_Color) as! String
        let BgColor = model.value(forKey: Constants.key_BgColor) as! String
        let Orientation = model.value(forKey: Constants.key_Orientation) as! String
        
        btn.setTitle(Text, for: .normal);
        Utility.setFontTo(view: btn, size: Size, style: Style, align: Orientation)
        
        
        Utility.setAutolayout(toView: btn, inView: self, attributes: "0,0,0,0", fieldPosition: .None,topView: UIView(), topViewAttibutes: nil,width: 0.0,alignment: nil);
        btn.setTitleColor(UIColor.init(hexString: Color), for: .normal)
        btn.backgroundColor = UIColor.init(hexString: BgColor)
        btn.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        addHeightContraint(toView: btn, height: 35)
    }
    @objc func addHeightContraint(toView : UIView, height: CGFloat){
        let metrics = ["height": height]
        let views : [String : Any] = ["toView":toView]
        let heightConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:[toView(height)]", options: [], metrics: metrics, views: views)
        
        NSLayoutConstraint.activate(heightConstraint)
    }
    @objc func btnTapped(){
        print("btn tapped")
        if btnTapHandler != nil{
            btnTapHandler!(self.tag, model)
        }
    }
    @objc func convertPostions(position : String) -> String{
//        var newPostion : String
//        let array = position.components(separatedBy: ",")
//        if array.count == 4 {
//            newPostion = array[1] + "," + array[2] + "," + array[3] + "," + array[0]
//        }else{
//            newPostion = position
//        }
        return position;
    }
}
