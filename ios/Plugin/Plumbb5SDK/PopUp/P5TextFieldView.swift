//
//  P5TextFieldView.swift
//  Plumb5SDK
//
//  Created by Shahid Akhtar Shaikh on 7/8/17.
//  Copyright © 2017 Plumb5. All rights reserved.
//

import UIKit

class P5TextFieldView: P5BaseFromView,UITextFieldDelegate {
    @objc var model:NSDictionary = [:]{
        didSet{
            drawTextField()
        }
    }
    @objc let textField = UITextField()
    @objc func drawTextField(){
        
        textField.borderStyle = .none
        let Text =  model.value(forKey: Constants.key_text) as! String
        textField.placeholder = Text;
        let Size = model.value(forKey: Constants.key_Size) as! String
        let Style = model.value(forKey: Constants.key_Style) as! String
        
        let Padding = convertPostions(position:model.value(forKey: Constants.key_Padding) as! String)
        let Color = model.value(forKey: Constants.key_Color) as! String
        let Category = model.value(forKey: Constants.key_Category) as! String
        let Orientation = model.value(forKey: Constants.key_Orientation) as! String
        
        
        textField.textColor = UIColor.init(named: Color)
        textField.delegate = self;
        textField.keyboardType = keyBoardType(fieldCategory: Category)
        
        Utility.setFontTo(view: textField, size: Size, style: Style, align: Orientation);
        let container = UIView.init()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        Utility.setboarderToView(view: container, fromParams: model,fillBg: true)
        Utility.setAutolayout(toView: textField, inView: self, attributes: Padding,fieldPosition: FieldPosition.None, topView: UIView(),topViewAttibutes: "", width:0.0, alignment: "nil");
        let BgColor = model.value(forKey: Constants.key_BgColor) as! String
        self.backgroundColor = UIColor.init(named: BgColor)
    }
    @objc func keyBoardType(fieldCategory:String) -> UIKeyboardType{
        switch fieldCategory {
        case "Name":
            return .default
        case "Emailid":
            return .emailAddress
        case "Phone":
            return .phonePad
            
        default:
            return .default
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    override func isFieldValid() -> Bool {
        let text = textField.text!
        if text.count > 0{
            if textField.keyboardType == .emailAddress {
               return isValidEmail(testStr: text)
            }else{
                return true
            }
           
        }else{
           return false
        }
    }
    @objc func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    override func fieldValue() -> String {
        return textField.text!;
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
