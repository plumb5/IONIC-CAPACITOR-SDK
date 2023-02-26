//
//  Utility.swift
//  Plumb5SDK
//
//  Created by Shahid Akhtar Shaikh on 6/13/17.
//  Copyright © 2017 Plumb5. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    func withTraits(traits:UIFontDescriptor.SymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor
            .withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
    
    func boldItalic() -> UIFont {
        return withTraits(traits: .traitBold, .traitItalic)
    }
    
}
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        if hexString.count == 0 {
            self.init(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 0.0)
        }else{
            var int = UInt64()
            Scanner(string: hex).scanHexInt64(&int)
            let a, r, g, b: UInt64
            switch hex.count {
            case 3: // RGB (12-bit)
                (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: // ARGB (32-bit)
                (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                (a, r, g, b) = (255, 0, 0, 0)
            }
            self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
        }
    }
}
enum FieldPosition{
    case VerticallyFirst
    case VerticallyLast
    case HorizontallyFirst
    case HorizontallyLast
    case HorizontallyMiddle
    case VerticallyMiddle
    case None
    
}
class Utility{
    
    public static var isDynamicHeight : Bool = false
    public class func setFontTo(view : UIView, size: String, style: String, align: String){
        var font : UIFont? = nil;
        switch style {
        case "Bold":
            font =  UIFont.boldSystemFont(ofSize: CGFloat((size as NSString).doubleValue))
        case "Italic":
            font =  UIFont.italicSystemFont(ofSize: CGFloat((size as NSString).doubleValue))
        case "Bold_Italic":
            font =  UIFont.boldSystemFont(ofSize: CGFloat((size as NSString).doubleValue)).boldItalic()
        default:
            font = UIFont.systemFont(ofSize: CGFloat((size as NSString).doubleValue))
            break
        }
        if view is UILabel{
            let label = view as! UILabel
            label.textAlignment = alignmnetFromString(align: align)
            label.font = font
        }else if view is UITextField{
            let textField = view as! UITextField
            textField.textAlignment = alignmnetFromString(align: align)
            textField.font = font
        }else if view is UIButton{
            let btn = view as! UIButton
            btn.titleLabel?.font = font
            btn.contentHorizontalAlignment = btnAlignmnetFromString(align: align)
            btn.setNeedsDisplay()
            
        }
    }
    public class func alignmnetFromString(align: String) ->NSTextAlignment{
        var alignment: NSTextAlignment = .natural
        switch align {
        case "Center":
            alignment = .center
        case "Left":
            alignment = .left
        case "Right":
            alignment = .right
        default:
            alignment = .natural
        }
        return alignment
    }
    public class func btnAlignmnetFromString(align: String) ->UIControl.ContentHorizontalAlignment{
        var alignment: UIControl.ContentHorizontalAlignment = .center
        switch align {
        case "Center":
            alignment = .center
        case "Left":
            alignment = .left
        case "Right":
            alignment = .right
        default:
            alignment = .center
        }
        return alignment
    }
    public class func setboarderToView(view: UIView, fromParams:NSDictionary, fillBg: Bool){
        let BgColor = fromParams.value(forKey: Constants.key_BgColor) as! String
        if BgColor.count >= 0 {
            if fillBg {
                view.backgroundColor = UIColor.init(hexString: BgColor)
            }
        }
        
        let Border = fromParams.value(forKey: Constants.key_Border) as! String
        if Border.count >= 0 {
            view.layer.borderColor = UIColor.init(hexString: Border).cgColor
        }
        
        let BorderWidth = fromParams.value(forKey:  Constants.key_BorderWidth) as! String
        view.layer.borderWidth = CGFloat((BorderWidth as NSString).doubleValue)
        
        let BorderRadius = fromParams.value(forKey:  Constants.key_BorderRadius) as! String
        view.layer.cornerRadius = CGFloat((BorderRadius as NSString).doubleValue)
        //        view.clipsToBounds = true;
    }
    public class func convertWidthPercentageToPixel(width : CGFloat, inView:UIView) -> CGFloat{
        var finalWidth : CGFloat = 0.0
        inView.layoutIfNeeded()
        let screenWidth = inView.frame.size.width//UIWindow.key?.bounds.size.width
        finalWidth = width * screenWidth/100.0
        return finalWidth
    }
    public class func convertHeighrPercentageToPixel(width : CGFloat) -> CGFloat{
        var finalWidth : CGFloat = 0.0
        //        let screenMatrix = UIScreen.main.scale
        let screenHeight : CGFloat = (UIWindow.key?.bounds.size.height)!
        finalWidth = screenHeight * width/100
        return finalWidth
    }
    class func calculateVerticalGap(topViewAttibutes: String?, topMargin:String) -> String{
        
        var topGap = topMargin;
        if topViewAttibutes != nil {
            let array = topViewAttibutes?.components(separatedBy: ",")
            if array?.count == 4 {
                let gap : CGFloat = CGFloat((array![3] as NSString).doubleValue) + CGFloat((topMargin as NSString).doubleValue)
                topGap = NSString(format: "%.2f", gap) as String
            }
        }
        return topGap
        
    }
    class func calculateHorizontalGap(topViewAttibutes: String?, leadingGap:String,fieldPosition: FieldPosition) -> String{
        
        var topGap = leadingGap;
        if topViewAttibutes != nil {
            let array = topViewAttibutes?.components(separatedBy: ",")
            if array?.count == 4 {
                var gap : CGFloat
                switch fieldPosition {
                case .HorizontallyMiddle,.HorizontallyLast:
                    gap = CGFloat((array![2] as NSString).doubleValue) + CGFloat((leadingGap as NSString).doubleValue)
                default:
                    gap  = CGFloat((array![0] as NSString).doubleValue) + CGFloat((leadingGap as NSString).doubleValue)
                }
                
                topGap = NSString(format: "%.2f", gap) as String
            }
        }
        return topGap
        
    }
    public class func setAutolayout(toView : UIView, inView: UIView, attributes:String, fieldPosition: FieldPosition, topView:UIView, topViewAttibutes:String?, width:CGFloat, alignment:String?){
        let newattributes = Utility.convertPixels(positions: attributes);
        var newtopViewAttibutes:String
        if topViewAttibutes != nil {
            newtopViewAttibutes = Utility.convertPixels(positions: topViewAttibutes!);
        }else{
            newtopViewAttibutes = "";
        }
        toView.translatesAutoresizingMaskIntoConstraints = false
        let array = newattributes.components(separatedBy: ",")
        let views : [String : Any] = ["toView":toView,"topView":topView]
        inView.addSubview(toView)
        var horizontalVisualString : String
        var verticalVisualString : String
        var viewWithWidth : String
        
        if width > 0 {
            viewWithWidth = "-[toView(width)]"
        }
        else if (array.count == 4){
            viewWithWidth = "-[toView]-" + array[2] + "-|"
        }else{
            viewWithWidth = "-[toView]-|"
        }
        var metrics : [String:Any] = [:]
        if array.count == 4 {
            var expectedWidth : CGFloat = convertWidthPercentageToPixel(width: width, inView: inView)
            expectedWidth  = expectedWidth - CGFloat((array[0] as NSString).doubleValue) - CGFloat((array[2] as NSString).doubleValue)
            metrics = ["width": expectedWidth]
            let verticalGap = calculateVerticalGap(topViewAttibutes: newtopViewAttibutes, topMargin: array[1])
            let HorizontalGap = calculateHorizontalGap(topViewAttibutes: newtopViewAttibutes, leadingGap: array[0], fieldPosition: fieldPosition)
            
            if alignment == "Left" {
                if width > 0 {
                    horizontalVisualString = "|-" + array[0] + "-[toView(width)]"
                }else{
                    horizontalVisualString = "|-" + array[0] + "-[toView]-" + array[2] + "-|"
                }
            }else if alignment == "Right"{
                if width > 0 {
                    horizontalVisualString = "[toView(width)]-|"
                }else{
                    horizontalVisualString = "|-" + array[0] + "-[toView]-" + array[2] + "-|"
                }
            }else if alignment == "Center"{
                if width > 0 {
                    horizontalVisualString = "[toView(width)]"
                    let centerXContraints = NSLayoutConstraint(item: toView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: inView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
                    centerXContraints.isActive = true
                }else{
                    horizontalVisualString = "|-" + array[0] + "-[toView]-" + array[2] + "-|"
                }
            }else{
                if width > 0 {
                    horizontalVisualString = "|-" + array[0] + "-[toView(width)]"
                }else{
                    horizontalVisualString = "|-" + array[0] + "-[toView]-" + array[2] + "-|"
                }
            }
            switch fieldPosition {
            case .VerticallyFirst:
                
                verticalVisualString = "V:|-"+array[1]+"-[toView]"
            case .VerticallyLast:
                if Utility.isDynamicHeight {
                    verticalVisualString = "V:[topView]-"+verticalGap+"-[toView]|"
                }else{
                    verticalVisualString = "V:[topView]-"+verticalGap+"-[toView]"
                }
            case .VerticallyMiddle:
                verticalVisualString = "V:[topView]-"+verticalGap+"-[toView]"
                
            case .HorizontallyFirst:
                horizontalVisualString = "|-" + array[0] + viewWithWidth
                verticalVisualString = "V:|-" + array[1] + "-[toView]-" + array[3] + "-|"
            case .HorizontallyMiddle:
                horizontalVisualString = "[topView]-"+HorizontalGap+viewWithWidth
                verticalVisualString = "V:|-" + array[1] + "-[toView]-" + array[3] + "-|"
            case .HorizontallyLast:
                
                if horizontalVisualString.hasSuffix("-|"){
                    horizontalVisualString = "[topView]-"+HorizontalGap+viewWithWidth
                }else{
                    horizontalVisualString = "[topView]-"+HorizontalGap+viewWithWidth + "-|"
                }
                verticalVisualString = "V:|-" + array[1] + "-[toView]-" + array[3] + "-|"
            default:
                horizontalVisualString = "|-" + array[0] + viewWithWidth
                verticalVisualString = "V:|-"+array[1]+"-[toView]-"+array[3]+"-|"
            }
        }else{
            horizontalVisualString = "|-[toView]-|"
            verticalVisualString = "V:|-[toView]-|"
        }
        
        let horizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: horizontalVisualString, options: [], metrics: metrics, views: views)
        let verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: verticalVisualString, options: [], metrics: metrics, views: views)
        NSLayoutConstraint.activate(horizontalConstraint)
        NSLayoutConstraint.activate(verticalConstraint)
    }
    public class func setAutolayoutToIndependentField(toView : UIView, inView: UIView, attributes:String, width:CGFloat, alignment:String?, fieldPosition: FieldPosition){
        let newattributes = Utility.convertPixels(positions: attributes);
        toView.translatesAutoresizingMaskIntoConstraints = false
        let array = newattributes.components(separatedBy: ",")
        let views : [String : Any] = ["toView":toView]
        inView.addSubview(toView)
        var horizontalVisualString : String
        var verticalVisualString : String
        var viewWithWidth : String
        if width > 0 {
            viewWithWidth = "-[toView(width)]"
        }
        else if (array.count == 4){
            viewWithWidth = "-[toView]-" + array[2] + "-|"
        }else{
            viewWithWidth = "-[toView]-|"
        }
        var metrics : [String:Any] = [:]
        if array.count == 4 {
            var expectedWidth : CGFloat = convertWidthPercentageToPixel(width: width, inView: inView)
            expectedWidth  = expectedWidth - CGFloat((array[0] as NSString).doubleValue) - CGFloat((array[2] as NSString).doubleValue)
            metrics = ["width": expectedWidth]
            if width > 0 {
                horizontalVisualString = "|-" + array[0] + "-[toView(width)]"
            }else{
                horizontalVisualString = "|-" + array[0] + "-[toView]-" + array[2] + "-|"
            }
            if alignment == "Top" {
                verticalVisualString = "V:|-"+array[1]+"-[toView]"
            }else{
                verticalVisualString = "V:[toView]-"+array[3]+"-|"
            }
            //            switch fieldPosition {
            //            case .None:
            //                horizontalVisualString = "|-[toView]-|"
            //                verticalVisualString = "V:|-[toView]-|"
            //            default:
            //
            //            }
            
        }else{
            horizontalVisualString = "|-[toView]-|"
            if alignment == "Top" {
                verticalVisualString = "V:|-[toView]"
            }else{
                verticalVisualString = "V:[toView]-|"
            }
        }
        
        let horizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: horizontalVisualString, options: [], metrics: metrics, views: views)
        let verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: verticalVisualString, options: [], metrics: metrics, views: views)
        NSLayoutConstraint.activate(horizontalConstraint)
        NSLayoutConstraint.activate(verticalConstraint)
    }
    public class func getVerticalFieldPosition(index: NSInteger, totalCount: NSInteger) -> FieldPosition{
        if totalCount == 0{
            return .None
        }
        if totalCount == 1{
            return .None
        }else if index == 0 {
            return .VerticallyFirst
        }else if(index == totalCount-1)
        {
            return .VerticallyLast
        }else{
            return .VerticallyMiddle
        }
    }
    public class func getHorizontalFieldPosition(index: NSInteger, totalCount: NSInteger) -> FieldPosition{
        if totalCount == 0{
            return .None
        }
        if index == 0 {
            return .HorizontallyFirst
        }else if(index == totalCount-1)
        {
            return .HorizontallyLast
        }else{
            return .HorizontallyMiddle
        }
    }
    
    public class func stringFromDate(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let dateString = formatter.string(from: date as Date)
        return dateString
    }
    
    public class func convertPixels(positions : String) -> String{
        let multipler:CGFloat = 1.5
        let comps:Array<String> = positions.components(separatedBy: ",")
        if comps.count == 4 {
            //            let p1 = CGFloat((comps[0] as NSString).doubleValue)
            var newPositionsArr: Array<String> = Array()
            newPositionsArr.append(NSString(format: "%.2f", CGFloat((comps[0] as NSString).doubleValue)*multipler) as String)
            newPositionsArr.append(NSString(format: "%.2f", CGFloat((comps[1] as NSString).doubleValue)*multipler) as String)
            newPositionsArr.append(NSString(format: "%.2f", CGFloat((comps[2] as NSString).doubleValue)*multipler) as String)
            newPositionsArr.append(NSString(format: "%.2f", CGFloat((comps[3] as NSString).doubleValue)*multipler) as String)
            return newPositionsArr.joined(separator: ",")
        }else{
            return positions;
        }
    }
}
