//
//  InAppBanner.swift
//  Plumb5SDK
//
//  Created by Shahid Akhtar Shaikh on 6/12/17.
//  Copyright © 2017 Plumb5. All rights reserved.
//

import UIKit


class InAppBanner: UIView, UITextFieldDelegate {
    
    let eventType: String = "Custom-InApp-Event"
    var formType : String = "Widget"
    var screenName : String = ""
    var  centerXContraints : NSLayoutConstraint?
    var  centerYContraints : NSLayoutConstraint?
    var  topContraints : NSLayoutConstraint?
    var  bottomContraints : NSLayoutConstraint?
    var  leadingContraint : NSLayoutConstraint?
    var  traillingContraint : NSLayoutConstraint?
    var  horizontalConstraints : [NSLayoutConstraint]?
    
    var uiFields : Array<UIView> =  Array()
    var uiIndependsFields : Array<UIView> =  Array()
    
    var fields : Array<NSDictionary> =  Array()
    var independentsFields : Array<NSDictionary> =  Array()
    var MobilePushId : Any!
    var widgetName : String!
    var formView:UIView!
    var viewContainer : UIView!
    var animation : String!
    var formContent : NSDictionary = [:]{
        didSet{
            refreshUI()
        }
    }
    var btnClose: UIButton?;
    var viewImpressionSubmitted = false
    func addOrientationNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        
    }
    func removeOrientationNotification(){
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    @objc func deviceRotated(){
        if formView != nil {
            formView.removeFromSuperview()
            formView = nil;
            showBanner()
        }
        
    }
    var dataModel:NSDictionary = [:]{
        didSet{
            let FormContent = dataModel["FormContent"] as! String
            let data = FormContent.data(using: String.Encoding.utf16)
            do{
                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves)
                if json is NSDictionary{
                    let jsonDic = json as? NSDictionary
                    formContent = jsonDic!;
                }
                print(json)
            }catch{
                print("Unable to parse json response");
                self.removeFromSuperview()
            }
        }
    }
    func refreshUI(){
        addOrientationNotification()
        let display = formContent.value(forKey: "Display") as! NSDictionary
        let Interval = display.value(forKey: "Interval") as! NSString
        Timer.scheduledTimer(timeInterval: TimeInterval(Interval.integerValue), target: self, selector:#selector(showBanner), userInfo: nil, repeats: false);
    }
    func animateBanner(animationType: String){
        if viewImpressionSubmitted == false {
            viewImpressionSubmitted = true
            P5SDKManager.updateFormResponse(mobileFormID: MobilePushId!, formResponse: formType, bannerView: "1", bannerClick: "0", bannerClose: "0", btnName: "",geofenceName: "",beaconName: "",screenName: screenName, widgetName: widgetName!)
        }
        
        if(animationType == "0"){
            return
        }
        let display = formContent.value(forKey: "Display") as! NSDictionary
        let position = display.value(forKey: Constants.key_Position) as! String
        self.layoutIfNeeded()
        switch animationType {
        case "1"://Slide  up
            if position == "Center"{
                centerYContraints?.constant = self.frame.size.height
                self.layoutIfNeeded()
                UIView.animate(withDuration: 0.5, animations: {
                    self.centerYContraints?.constant = 0
                    self.layoutIfNeeded()
                }, completion: { (finished) in
                    
                })
            }else if position == "Top"{
                topContraints?.constant = self.frame.size.height
                self.layoutIfNeeded()
                UIView.animate(withDuration: 0.5, animations: {
                    self.topContraints?.constant = 20
                    self.layoutIfNeeded()
                }, completion: { (finished) in
                    
                })
            }else {
                bottomContraints?.constant = self.frame.size.height
                self.layoutIfNeeded()
                UIView.animate(withDuration: 0.5, animations: {
                    self.bottomContraints?.constant = 0
                    self.layoutIfNeeded()
                }, completion: { (finished) in
                    
                })
            }
            
            
        case "2": //Slide  down
            if position == "Center"{
                centerYContraints?.constant = -self.frame.size.height
                self.layoutIfNeeded()
                UIView.animate(withDuration: 0.5, animations: {
                    self.centerYContraints?.constant = 0
                    self.layoutIfNeeded()
                }, completion: { (finished) in
                    
                })
            }else if position == "Top"{
                topContraints?.constant = -self.frame.size.height
                self.layoutIfNeeded()
                UIView.animate(withDuration: 0.5, animations: {
                    self.topContraints?.constant = 20
                    self.layoutIfNeeded()
                }, completion: { (finished) in
                    
                })
            }else{
                bottomContraints?.constant = -self.frame.size.height
                self.layoutIfNeeded()
                UIView.animate(withDuration: 0.5, animations: {
                    self.bottomContraints?.constant = 0
                    
                    self.layoutIfNeeded()
                }, completion: { (finished) in
                    
                })
            }
            
        case "3": //Slide  Left
            leadingContraint?.constant = -self.frame.size.width
            centerXContraints?.constant = -self.frame.size.width/2
            traillingContraint?.constant = -self.frame.size.width
            self.layoutIfNeeded()
            UIView.animate(withDuration: 0.5, animations: {
                self.centerXContraints?.constant = 0
                self.leadingContraint?.constant = 7;
                self.traillingContraint?.constant = -7;
                self.layoutIfNeeded()
            }, completion: { (finished) in
                
            })
        case "4": //Slide  Right
            self.layoutIfNeeded()
            leadingContraint?.constant = self.frame.size.width
            centerXContraints?.constant = (self.frame.size.width/2)*3
            traillingContraint?.constant = -self.frame.size.width
            self.layoutIfNeeded()
            UIView.animate(withDuration: 0.5, animations: {
                self.centerXContraints?.constant = 0
                self.leadingContraint?.constant = 7;
                self.traillingContraint?.constant = -7;
                self.layoutIfNeeded()
            }, completion: { (finished) in
                
            })
        default:
            break;
        }
    }
    @objc func showBanner(){
        btnClose?.removeFromSuperview()
        let pushId = dataModel[Constants.key_MobileFormId]
        widgetName = dataModel["WidgetName"] as? String
        //        if pushId is String{
        //            MobilePushId = pushId as! String
        //        }else{
        //            MobilePushId = String(describing: pushId)
        //        }
        MobilePushId = pushId
        self.backgroundColor = UIColor.init(white: 1.0, alpha: 0.3)
        let display = formContent.value(forKey: "Display") as! NSDictionary
        drawBackgroung(display: display );
        let Fields : NSArray = formContent.value(forKey: "Fields") as! NSArray
        drawFields(fields: Fields as NSArray)
        animation = display.value(forKey: Constants.key_Animation) as? String
        animateBanner(animationType: animation)
    }
    func drawBackgroung(display : NSDictionary){
        
        formView = UIView.init()
        formView.translatesAutoresizingMaskIntoConstraints = false
        formView.clipsToBounds = true
        
        viewContainer = UIView()
        viewContainer.clipsToBounds = true
        //        viewContainer.backgroundColor = UIColor.yellow
        
        let Padding = convertLayoutPostions(position: display.value(forKey: Constants.key_Padding) as! String)
        let views : [String : Any] = ["formView":formView]
        self.addSubview(formView)
        var horizontalVisualString : String
        let metrics : [String:Any] = [:]
        horizontalVisualString = "|-7-[formView]-7-|"
        let verticalVisualString = "V:|-(>=20)-[formView]-(>=7)-|"
        let position = display.value(forKey: Constants.key_Position) as! String
        let height = display.value(forKey: Constants.key_Height) as! String
        switch position {
        case "Center":// Center on the screen
            if height == "0" {
                Utility.isDynamicHeight = true;
            }else if(height == "100"){
                Utility.isDynamicHeight = false;
                let staticHeightMatrcs = ["height":Utility.convertHeighrPercentageToPixel(width:CGFloat((height as NSString).doubleValue) )]
                let verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[formView]-7-|", options: [], metrics: staticHeightMatrcs, views: views)
                NSLayoutConstraint.activate(verticalConstraint)
            }
            else{
                Utility.isDynamicHeight = false;
                let staticHeightMatrcs = ["height":Utility.convertHeighrPercentageToPixel(width:CGFloat((height as NSString).doubleValue) )]
                let verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:[formView(height)]", options: [], metrics: staticHeightMatrcs, views: views)
                NSLayoutConstraint.activate(verticalConstraint)
            }
            centerYContraints = NSLayoutConstraint(item: formView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
            centerYContraints?.isActive = true
            
            
        case "Top":// Top on the screen
            if height == "0" {
                Utility.isDynamicHeight = true;
                
            }else if(height == "100"){
                Utility.isDynamicHeight = false;
                let staticHeightMatrcs = ["height":Utility.convertHeighrPercentageToPixel(width:CGFloat((height as NSString).doubleValue) )]
                let verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[formView]-7-|", options: [], metrics: staticHeightMatrcs, views: views)
                NSLayoutConstraint.activate(verticalConstraint)
            }
            else{
                Utility.isDynamicHeight = false;
                let staticHeightMatrcs = ["height":Utility.convertHeighrPercentageToPixel(width:CGFloat((height as NSString).doubleValue) )]
                let verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:[formView(height)]", options: [], metrics: staticHeightMatrcs, views: views)
                NSLayoutConstraint.activate(verticalConstraint)
            }
            topContraints = NSLayoutConstraint(item: formView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 20)
            topContraints?.isActive = true
        case "Bottom":// Top on the screen
            if height == "0" {
                Utility.isDynamicHeight = true;
            }else if(height == "100"){
                Utility.isDynamicHeight = false;
                let staticHeightMatrcs = ["height":Utility.convertHeighrPercentageToPixel(width:CGFloat((height as NSString).doubleValue) )]
                let verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[formView]-7-|", options: [], metrics: staticHeightMatrcs, views: views)
                NSLayoutConstraint.activate(verticalConstraint)
            }
            else{
                Utility.isDynamicHeight = false;
                let staticHeightMatrcs = ["height":Utility.convertHeighrPercentageToPixel(width:CGFloat((height as NSString).doubleValue) )]
                let verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:[formView(height)]", options: [], metrics: staticHeightMatrcs, views: views)
                NSLayoutConstraint.activate(verticalConstraint)
            }
            bottomContraints = NSLayoutConstraint(item: formView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
            bottomContraints?.isActive = true
            
        default:
            break
        }
        centerXContraints = NSLayoutConstraint(item: formView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        centerXContraints?.isActive = true
        leadingContraint = NSLayoutConstraint(item: formView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 7)
        leadingContraint?.isActive = true
        traillingContraint = NSLayoutConstraint(item: formView, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: -7)
        traillingContraint?.isActive = true
        //        horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: horizontalVisualString, options: [], metrics: metrics, views: views)
        //        NSLayoutConstraint.activate(horizontalConstraints!)
        
        let VerticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: verticalVisualString, options: [], metrics: metrics, views: views)
        NSLayoutConstraint.activate(VerticalConstraint)
        
        let BgColor = display.value(forKey: "BgColor") as! String
        formView.backgroundColor = UIColor.init(named: BgColor)
        
        Utility.setboarderToView(view: formView, fromParams: display, fillBg: true)
        
        
        
        let BgImage = display.value(forKey: "BgImage") as! String
        if BgImage != nil && BgImage.count != 0{
            let bgImageView = UIImageView()
            bgImageView.contentMode = .scaleToFill
            bgImageView.clipsToBounds = true
            
            
            bgImageView.frame = formView.frame
            bgImageView.autoresizingMask = [.flexibleWidth , .flexibleHeight ]
            //            bgImageView.translatesAutoresizingMaskIntoConstraints = false
            formView.addSubview(bgImageView)
            //            let ImageViews : [String : Any] = ["bgImageView":bgImageView]
            //            let imageHorizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "|-0-[bgImageView]-0-|", options: .directionLeadingToTrailing, metrics: metrics, views: ImageViews)
            //            let imageVerticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[bgImageView]-0-|", options: .directionLeadingToTrailing, metrics: metrics, views: ImageViews)
            //            NSLayoutConstraint.activate(imageHorizontalConstraint)
            //            NSLayoutConstraint.activate(imageVerticalConstraint)
            
            let activityIndicator = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.medium)
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            formView.addSubview(activityIndicator)
            let activityCenterYContraints = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: formView, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
            let activityCenterXContraints = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: formView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
            activityCenterYContraints.isActive = true
            activityCenterYContraints.isActive = true
            
            
            downloadImageWithUrl(urlString: BgImage, imageView: bgImageView, activityIndicator: activityIndicator, resizeImageView: false)
        }
        Utility.setAutolayout(toView: viewContainer, inView: formView, attributes: Padding, fieldPosition: FieldPosition.None, topView: UIView(), topViewAttibutes: "nil", width: 0, alignment: "nil")
        let Close = display.value(forKey: "Close") as! String
        
        if Close == "1"{
            btnClose = UIButton.init(type: .custom)
            btnClose?.setTitleColor(UIColor.blue, for: .normal)
            let frameWorkBundle = Bundle(for: type(of: self))
            let imgClose = UIImage.init(named: "ic_close", in: frameWorkBundle, compatibleWith: nil);
            btnClose?.setImage(imgClose, for: .normal)
            self.addSubview(btnClose!)
            btnClose?.translatesAutoresizingMaskIntoConstraints = false
            btnClose?.addTarget(self, action: #selector(formCloseTapped), for: .touchUpInside)
            
            let metrics = ["padding": -35.0]
            let btnViews : [String : Any] = ["btnClose":btnClose!,"formView":formView]
            let btnHorizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "[formView]-padding-[btnClose(40)]", options: [], metrics: metrics, views: btnViews)
            let btnVerticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:[btnClose(40)]-padding-[formView]", options: [], metrics: metrics, views: btnViews)
            NSLayoutConstraint.activate(btnHorizontalConstraint)
            NSLayoutConstraint.activate(btnVerticalConstraint)
        }
    }
    @objc  func formCloseTapped() {
        
        P5SDKManager.updateFormResponse(mobileFormID: MobilePushId!, formResponse: formType, bannerView: "0", bannerClick: "0", bannerClose: "1", btnName: "",geofenceName: "",beaconName: "", screenName: screenName,widgetName: widgetName!)
        removeDialog()
        
    }
    func removeDialog() {
        self.removeFromSuperview()
        stopAllEvents()
        removeOrientationNotification()
    }
    
    func stopAllEvents(){
        for view in uiFields{
            if view is P5CountDownView {
                let coundtdownTimer = view as! P5CountDownView
                coundtdownTimer.viewRemoved()
            }
        }
    }
    func filterFields(fields: NSArray){
        self.independentsFields.removeAll()
        self.fields.removeAll()
        self.uiFields.removeAll()
        self.uiIndependsFields.removeAll()
        for index in 0...fields.count-1{
            let field = fields.object(at: index) as! NSDictionary
            let Align = field.value(forKey: Constants.key_Align) as! String
            if Align == "Top" || Align == "Bottom"{
                self.independentsFields.append(field)
            }else{
                self.fields.append(field)
            }
        }
    }
    func drawFields(fields : NSArray){
        filterFields(fields: fields)
        drawFields(isIndependentFields: false)
        drawFields(isIndependentFields: true)
        //        for index in 0...self.fields.count-1{
        //            let field = self.fields[index]
        //            let fieldPosition =  Utility.getVerticalFieldPosition(index: index, totalCount: self.fields.count)
        //            var topView : UIView?
        //            var topViewParams : NSDictionary?
        //            if index == 0 {
        //                topView = UIView()
        //                topViewParams = nil
        //            }else{
        //                topView = uiFields[index-1]
        //                if topView ==  nil{
        //                    topView = UIView()
        //                    topViewParams = nil
        //                }else{
        //                  topViewParams = fields.object(at: index-1) as? NSDictionary
        //                }
        //
        //            }
        //            let Type = field.value(forKey: Constants.key_Type) as! String;
        //            switch Type {
        //            case "Tv":
        //                drawTVWithParams(params: field,fieldPosition: fieldPosition,topView: topView!,topViewParams: topViewParams)
        //            case "Et":
        //                drawEtWithParams(params: field,fieldPosition: fieldPosition,topView: topView!,topViewParams: topViewParams)
        //            case "Cb" :
        //                drawCbWithParams(params: field,fieldPosition: fieldPosition,topView: topView!,topViewParams: topViewParams)
        //            case "Btn":
        //                drawBtnWithParams(params: field,fieldPosition: fieldPosition,topView: topView!,topViewParams: topViewParams)
        //            case "Rg":
        //                drawRadioGroupParams(params: field,fieldPosition: fieldPosition,topView: topView!,topViewParams: topViewParams)
        //            case "Sp":
        //                drawSpinner(params: field,fieldPosition: fieldPosition,topView: topView!,topViewParams: topViewParams)
        //            case "Img":
        //                drawImageWithParams(params: field,fieldPosition: fieldPosition,topView: topView!,topViewParams: topViewParams)
        //            case "Cd":
        //                drawCountDownViewParams(params: field,fieldPosition: fieldPosition,topView: topView!,topViewParams: topViewParams)
        //            case "Rb":
        //                drawRatingBarParams(params: field,fieldPosition: fieldPosition,topView: topView!,topViewParams: topViewParams)
        //                break
        //            default:
        //                uiFields.append(uiFields[index-1])
        //                break;
        //            }
        //        }
    }
    func drawFields(isIndependentFields: Bool){
        var allFields : Array<NSDictionary>
        if isIndependentFields {
            allFields = self.independentsFields
        }else{
            allFields = self.fields
        }
        if  allFields.count == 0 {
            return
        }
        var index = 0
        while index < allFields.count{
            let fieldValue = allFields[index]
            
            var topView : UIView?
            var topViewParams : NSDictionary?
            if index == 0 {
                topView = UIView()
                topViewParams = nil
            }else{
                if isIndependentFields{
                    topView = uiIndependsFields[index-1]
                }else{
                    topView = uiFields[index-1]
                }
                
                if topView ==  nil{
                    topView = UIView()
                    topViewParams = nil
                }else{
                    topViewParams = allFields[index-1]
                }
                
            }
            var lViewContainer = viewContainer
            let horizontalAlign = fieldValue.value(forKey: Constants.key_Group)
            let groupCount = (horizontalAlign as! NSString).integerValue
            var fieldsToDraw : Array<NSDictionary> = Array()
            fieldsToDraw.append(fieldValue)
            if groupCount > 1 {
                lViewContainer = UIView.init()
                lViewContainer?.translatesAutoresizingMaskIntoConstraints = false
                
                let Margin = "0,0,0,0"
                let Align = fieldValue.value(forKey: Constants.key_Align) as! String
                var topViewMargin = ""
                if topViewParams != nil{
                    topViewMargin = topViewParams?.value(forKey: Constants.key_Margin) as! String
                }
                if isIndependentFields {
                    Utility.setAutolayoutToIndependentField(toView: lViewContainer!, inView: viewContainer, attributes: Margin, width:  0.0, alignment:  Align, fieldPosition: Utility.getVerticalFieldPosition(index: index+groupCount-1, totalCount: allFields.count))
                }else{
                    Utility.setAutolayout(toView: lViewContainer!, inView: viewContainer, attributes: Margin, fieldPosition: Utility.getVerticalFieldPosition(index: index+groupCount-1, totalCount: allFields.count),topView: topView!, topViewAttibutes: topViewMargin, width: 0.0,alignment: Align);
                }
                let startIndex = index+1
                let endIndex = index+groupCount-1
                for tIndex in startIndex...endIndex{
                    if tIndex < allFields.count {
                        let nextField = allFields[tIndex]
                        fieldsToDraw.append(nextField)
                    }
                }
            }
            for fieldIndex in 0...fieldsToDraw.count-1{
                let field = fieldsToDraw[fieldIndex]
                var fieldPosition =  Utility.getVerticalFieldPosition(index: index, totalCount: allFields.count)
                
                if fieldsToDraw.count == 1{
                    fieldPosition =  Utility.getVerticalFieldPosition(index: index, totalCount: allFields.count)
                }else{
                    fieldPosition =  Utility.getHorizontalFieldPosition(index: fieldIndex, totalCount: fieldsToDraw.count)
                    if fieldIndex == 0 {
                        topView = UIView()
                        topViewParams = nil
                    }else{
                        topView = lViewContainer?.subviews.last
                        topViewParams = fieldsToDraw[fieldIndex-1]
                        //
                        //                        if topView ==  nil{
                        //                            topView = UIView()
                        //                            topViewParams = nil
                        //                        }else{
                        //                            topViewParams = allFields[index-1]
                        //                        }
                        
                    }
                }
                let Type = field.value(forKey: Constants.key_Type) as! String;
                switch Type {
                case "Tv":
                    drawTVWithParams(params: field,fieldPosition: fieldPosition,topView: topView!,topViewParams: topViewParams,isIndependentField: isIndependentFields,inview: lViewContainer!, horizontalGroupCount: fieldsToDraw.count)
                case "Et":
                    formType = "Form"
                    drawEtWithParams(params: field,fieldPosition: fieldPosition,topView: topView!,topViewParams: topViewParams,isIndependentField: isIndependentFields,inview: lViewContainer!, horizontalGroupCount: fieldsToDraw.count)
                case "Cb" :
                    formType = "Form"
                    drawCbWithParams(params: field,fieldPosition: fieldPosition,topView: topView!,topViewParams: topViewParams,isIndependentField: isIndependentFields,inview: lViewContainer!, horizontalGroupCount: fieldsToDraw.count)
                case "Btn":
                    drawBtnWithParams(params: field,fieldPosition: fieldPosition,topView: topView!,topViewParams: topViewParams,isIndependentField: isIndependentFields,inview: lViewContainer!, horizontalGroupCount: fieldsToDraw.count)
                case "Rg":
                    formType = "Form"
                    drawRadioGroupParams(params: field,fieldPosition: fieldPosition,topView: topView!,topViewParams: topViewParams,isIndependentField: isIndependentFields,inview: lViewContainer!, horizontalGroupCount: fieldsToDraw.count)
                case "Sp":
                    formType = "Form"
                    drawSpinner(params: field,fieldPosition: fieldPosition,topView: topView!,topViewParams: topViewParams,isIndependentField: isIndependentFields,inview: lViewContainer!, horizontalGroupCount: fieldsToDraw.count)
                case "Img":
                    drawImageWithParams(params: field,fieldPosition: fieldPosition,topView: topView!,topViewParams: topViewParams,isIndependentField: isIndependentFields,inview: lViewContainer!, horizontalGroupCount: fieldsToDraw.count)
                case "Cd":
                    formType = "Form"
                    drawCountDownViewParams(params: field,fieldPosition: fieldPosition,topView: topView!,topViewParams: topViewParams,isIndependentField: isIndependentFields,inview: lViewContainer!, horizontalGroupCount: fieldsToDraw.count)
                case "Rb":
                    formType = "Form"
                    drawRatingBarParams(params: field,fieldPosition: fieldPosition,topView: topView!,topViewParams: topViewParams,isIndependentField: isIndependentFields,inview: lViewContainer!, horizontalGroupCount: fieldsToDraw.count)
                    break
                default:
                    allFields.append(allFields[index-1])
                    break;
                }
            }
            index = index+groupCount
        }
    }
    
    func drawTVWithParams(params : NSDictionary, fieldPosition:FieldPosition, topView:UIView, topViewParams : NSDictionary?, isIndependentField: Bool, inview: UIView, horizontalGroupCount:NSInteger){
        let lable = UILabel();
        let Text =  params.value(forKey: Constants.key_text) as! String
        lable.text = Text;
        lable.numberOfLines = 0
        let Size = params.value(forKey: Constants.key_Size) as! String
        let Style = params.value(forKey: Constants.key_Style) as! String
        
        var Width = params.value(forKey: Constants.key_Width) as! String
        let Padding = params.value(forKey: Constants.key_Padding) as! String
        let Margin = params.value(forKey: Constants.key_Margin) as! String
        let Align = params.value(forKey: Constants.key_Align) as! String
        let Color = params.value(forKey: Constants.key_Color) as! String
        let Orientation = params.value(forKey: Constants.key_Orientation) as! String
        lable.textColor = UIColor.init(named: Color)
        
        Utility.setFontTo(view: lable, size: Size, style: Style, align: Orientation);
        
        let labelContainer = UIView.init()
        labelContainer.translatesAutoresizingMaskIntoConstraints = false
        
        var topViewMargin = ""
        if topViewParams != nil{
            topViewMargin = topViewParams?.value(forKey: Constants.key_Margin) as! String
        }
        var containerfieledWidth:CGFloat = 0.0
        var fieldAlign : String = Align
        if horizontalGroupCount > 1 {
            containerfieledWidth = CGFloat(100/horizontalGroupCount)
            Width = "0"
            fieldAlign = "Left"
        }else{
            containerfieledWidth = CGFloat((Width as NSString).doubleValue)
        }
        if isIndependentField {
            Utility.setAutolayoutToIndependentField(toView: labelContainer, inView: inview, attributes:convertPostions(position: Margin), width:  containerfieledWidth, alignment:  fieldAlign, fieldPosition: fieldPosition)
        }else{
            Utility.setAutolayout(toView: labelContainer, inView: inview, attributes: convertPostions(position: Margin), fieldPosition: fieldPosition,topView: topView, topViewAttibutes: convertPostions(position: topViewMargin), width: containerfieledWidth,alignment: fieldAlign);
        }
        Utility.setAutolayout(toView: lable, inView: labelContainer, attributes: convertPostions(position: Padding),fieldPosition: FieldPosition.None, topView: topView,topViewAttibutes: "nil", width: CGFloat((Width as NSString).doubleValue), alignment: "nil");
        let BgColor = params.value(forKey: Constants.key_BgColor) as! String
        labelContainer.backgroundColor = UIColor.init(named: BgColor)
        if isIndependentField {
            self.uiIndependsFields.append(labelContainer)
        }else{
            self.uiFields.append(labelContainer)
        }
    }
    func drawEtWithParams(params : NSDictionary, fieldPosition:FieldPosition, topView:UIView, topViewParams : NSDictionary?, isIndependentField: Bool, inview: UIView , horizontalGroupCount:NSInteger){
        let textfield = P5TextFieldView()
        let Margin = convertPostions(position: params.value(forKey: Constants.key_Margin) as! String)
        var Width = params.value(forKey: Constants.key_Width) as! String
        let Align = params.value(forKey: Constants.key_Align) as! String
        
        var topViewMargin = ""
        if topViewParams != nil{
            topViewMargin = convertPostions(position: topViewParams?.value(forKey: Constants.key_Margin) as! String)
        }
        var containerfieledWidth:CGFloat = 0.0
        var fieldAlign : String = Align
        if horizontalGroupCount > 1 {
            containerfieledWidth = CGFloat(100/horizontalGroupCount)
            Width = "0"
            fieldAlign = "Left"
        }else{
            containerfieledWidth = CGFloat((Width as NSString).doubleValue)
        }
        if isIndependentField{
            Utility.setAutolayoutToIndependentField(toView: textfield, inView: inview, attributes: Margin, width: containerfieledWidth, alignment: fieldAlign, fieldPosition: fieldPosition)
        }else{
            Utility.setAutolayout(toView: textfield, inView: inview, attributes: Margin, fieldPosition: fieldPosition,topView: topView,topViewAttibutes: topViewMargin, width:containerfieledWidth , alignment: fieldAlign);
        }
        Utility.setboarderToView(view: textfield, fromParams: params,fillBg: true)
        textfield.tag = uiFields.count
        textfield.model = params;
        if isIndependentField {
            self.uiIndependsFields.append(textfield)
        }else{
            self.uiFields.append(textfield)
        }
    }
    func drawCbWithParams(params : NSDictionary, fieldPosition:FieldPosition, topView:UIView, topViewParams : NSDictionary?, isIndependentField: Bool, inview: UIView, horizontalGroupCount:NSInteger){
        let checkBox = P5CheckBox()
        let Text =  params.value(forKey: Constants.key_text) as! String
        checkBox.setTitle(Text, for: .normal)
        let Size = params.value(forKey: Constants.key_Size) as! String
        let Style = params.value(forKey: Constants.key_Style) as! String
        
        let Width = params.value(forKey: Constants.key_Width) as! String
        let Padding = convertPostions(position: params.value(forKey: Constants.key_Padding) as! String)
        let Margin = convertPostions(position: params.value(forKey: Constants.key_Margin) as! String)
        let Align = params.value(forKey: Constants.key_Align) as! String
        let Color = params.value(forKey: Constants.key_Color) as! String
        let Orientation = params.value(forKey: Constants.key_Orientation) as! String
        checkBox.setTitleColor(UIColor.init(named: Color), for: .normal)
        checkBox.setTitleColor(UIColor.init(named: Color), for: .selected)
        
        Utility.setFontTo(view: checkBox, size: Size, style: Style, align: Orientation);
        let container = UIView.init()
        container.translatesAutoresizingMaskIntoConstraints = false
        Utility.setboarderToView(view: container, fromParams: params,fillBg: true)
        var topViewMargin = ""
        if topViewParams != nil{
            topViewMargin = convertPostions(position: topViewParams?.value(forKey: Constants.key_Margin) as! String)
        }
        if isIndependentField {
            Utility.setAutolayoutToIndependentField(toView: container, inView: inview, attributes: Margin, width: CGFloat((Width as NSString).doubleValue), alignment: Align,fieldPosition: fieldPosition)
        }else{
            Utility.setAutolayout(toView: container, inView: inview, attributes: Margin, fieldPosition: fieldPosition,topView: topView,topViewAttibutes: topViewMargin, width: CGFloat((Width as NSString).doubleValue), alignment: Align);
        }
        Utility.setAutolayout(toView: checkBox, inView: container, attributes: Padding,fieldPosition: FieldPosition.None, topView: topView,topViewAttibutes: "nil", width:0.0 , alignment: "nil");
        checkBox.configureButton()
        if isIndependentField {
            self.uiIndependsFields.append(container)
        }else{
            self.uiFields.append(container)
        }
    }
    func drawBtnWithParams(params : NSDictionary, fieldPosition:FieldPosition, topView:UIView, topViewParams : NSDictionary?, isIndependentField: Bool, inview: UIView, horizontalGroupCount:NSInteger){
        let button = P5ButtonView()
        let Margin = convertPostions(position: params.value(forKey: Constants.key_Padding) as! String)
        var Width = params.value(forKey: Constants.key_Width) as! String
        let Align = params.value(forKey: Constants.key_Align) as! String
        
        var topViewMargin = ""
        if topViewParams != nil{
            topViewMargin = convertPostions(position: topViewParams?.value(forKey: Constants.key_Margin) as! String)
        }
        var containerfieledWidth:CGFloat = 0.0
        var fieldAlign : String = Align
        if horizontalGroupCount > 1 {
            containerfieledWidth = CGFloat(100/horizontalGroupCount)
            Width = "0"
            fieldAlign = "Left"
        }else{
            containerfieledWidth = CGFloat((Width as NSString).doubleValue)
        }
        if isIndependentField{
            Utility.setAutolayoutToIndependentField(toView: button, inView: inview, attributes: Margin, width: containerfieledWidth, alignment: fieldAlign, fieldPosition: fieldPosition)
        }else{
            Utility.setAutolayout(toView: button, inView: inview, attributes: Margin, fieldPosition: fieldPosition,topView: topView,topViewAttibutes: topViewMargin, width:containerfieledWidth , alignment: fieldAlign);
        }
        Utility.setboarderToView(view: button, fromParams: params,fillBg: false)
        button.tag = uiFields.count
        if isIndependentField {
            self.uiIndependsFields.append(button)
        }else{
            self.uiFields.append(button)
        }
        button.model = params;
        button.btnTapHandler = { (index : Int, params : NSDictionary) in
            self.performActionForBtn(params: params)
        }
    }
    
    func drawRadioGroupParams(params : NSDictionary, fieldPosition:FieldPosition, topView:UIView, topViewParams : NSDictionary?, isIndependentField: Bool, inview: UIView, horizontalGroupCount:NSInteger){
        let radioGroup = P5RadioGrpup()
        let Margin = convertPostions(position: params.value(forKey: Constants.key_Margin) as! String)
        let Width = params.value(forKey: Constants.key_Width) as! String
        let Align = params.value(forKey: Constants.key_Align) as! String
        
        var topViewMargin = ""
        if topViewParams != nil{
            topViewMargin = convertPostions(position: topViewParams?.value(forKey: Constants.key_Margin) as! String)
        }
        if isIndependentField{
            Utility.setAutolayoutToIndependentField(toView: radioGroup, inView: inview, attributes: Margin, width: CGFloat((Width as NSString).doubleValue), alignment: Align, fieldPosition: fieldPosition)
        }else{
            Utility.setAutolayout(toView: radioGroup, inView: inview, attributes: Margin, fieldPosition: fieldPosition,topView: topView,topViewAttibutes: topViewMargin, width:CGFloat((Width as NSString).doubleValue) , alignment: Align);
        }
        Utility.setboarderToView(view: radioGroup, fromParams: params,fillBg: true)
        if isIndependentField {
            self.uiIndependsFields.append(radioGroup)
        }else{
            self.uiFields.append(radioGroup)
        }
        radioGroup.model = params;
        
    }
    func drawSpinner(params : NSDictionary, fieldPosition:FieldPosition, topView:UIView, topViewParams : NSDictionary?, isIndependentField: Bool, inview: UIView, horizontalGroupCount: NSInteger) {
        let container = P5SpinnerContainer()
        container.translatesAutoresizingMaskIntoConstraints = false
        let Text =  params.value(forKey: Constants.key_text) as! String
        let Size = params.value(forKey: Constants.key_Size) as! String
        let Style = params.value(forKey: Constants.key_Style) as! String
        
        let Width = params.value(forKey: Constants.key_Width) as! String
        let Padding = convertPostions(position: params.value(forKey: Constants.key_Padding) as! String)
        let Margin = convertPostions(position: params.value(forKey: Constants.key_Margin) as! String)
        let Align = params.value(forKey: Constants.key_Align) as! String
        let Color = params.value(forKey: Constants.key_Color) as! String
        let BgColor = params.value(forKey: Constants.key_BgColor) as! String
        let Orientation = params.value(forKey: Constants.key_Orientation) as! String
        
        var topViewMargin = ""
        if topViewParams != nil{
            topViewMargin = convertPostions(position: topViewParams?.value(forKey: Constants.key_Margin) as! String)
        }
        if isIndependentField{
            Utility.setAutolayoutToIndependentField(toView: container, inView: inview, attributes: Margin, width: CGFloat((Width as NSString).doubleValue), alignment: Align, fieldPosition: fieldPosition)
        }else{
            Utility.setAutolayout(toView: container, inView: inview, attributes: Margin, fieldPosition: fieldPosition,topView: topView,topViewAttibutes: topViewMargin, width: CGFloat((Width as NSString).doubleValue), alignment: Align);
        }
        Utility.setboarderToView(view: container, fromParams: params,fillBg: true)
        
        let btn = UIButton.init(type: .custom)
        btn.tag = uiFields.count
        let defaultValue = Text.components(separatedBy: ",")[0]
        btn.setTitleColor(UIColor.init(named: Color), for: .normal)
        btn.backgroundColor = UIColor.init(named: BgColor)
        btn.setTitle(defaultValue, for: .normal);
        btn.addTarget(self, action: #selector(spinnerTapped), for: .touchUpInside)
        Utility.setFontTo(view: btn, size: Size, style: Style, align: Orientation)
        
        Utility.setAutolayout(toView: btn, inView: container, attributes: Padding, fieldPosition: FieldPosition.None,topView: topView,topViewAttibutes: "nil", width:0.0,alignment: "nil");
        let downArrow = UIImageView()
        downArrow.translatesAutoresizingMaskIntoConstraints = false
        let frameWorkBundle = Bundle(for: type(of: self))
        let imgDownArrow = UIImage.init(named: "downArrow", in: frameWorkBundle, compatibleWith: nil);
        downArrow.image = imgDownArrow
        container.addSubview(downArrow)
        let views : [String : Any] = ["downArrow":downArrow,"container":container]
        let horizontalVisualString = "[downArrow(15)]-7-|"
        let verticalVisualString = "V:[downArrow(15)]"
        let horizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: horizontalVisualString, options: [], metrics: nil, views: views)
        let verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: verticalVisualString, options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(horizontalConstraint)
        NSLayoutConstraint.activate(verticalConstraint)
        let arrowCenterYContraints = NSLayoutConstraint(item: downArrow, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: container, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        arrowCenterYContraints.isActive = true
        if isIndependentField {
            self.uiIndependsFields.append(container)
        }else{
            self.uiFields.append(container)
        }
    }
    @objc  func spinnerTapped(btn : UIButton){
        let tag = btn.tag
        let Fields : NSArray = formContent.value(forKey: "Fields") as! NSArray
        let params = Fields[tag] as! NSDictionary
        let Type = params.value(forKey: Constants.key_Type) as! String
        if !(Type == "Sp") {
            print("spinnerTapped: Somthing wrong here")
            return
        }
        let pickerView = P5PickerView()
        let Text =  params.value(forKey: Constants.key_text) as! String
        pickerView.selectItem = btn.titleLabel?.text
        pickerView.text = Text;
        pickerView.frame = self.bounds
        pickerView.translatesAutoresizingMaskIntoConstraints = true
        addSubview(pickerView);
        pickerView.completion = {(selectedItem: String) in
            btn.setTitle(selectedItem, for: .normal)
            let spinner = self.uiFields[tag]
            if spinner is P5SpinnerContainer {
                let view = spinner as? P5SpinnerContainer
                view?.selectItem = selectedItem
            }
        }
    }
    
    func drawImageWithParams(params : NSDictionary, fieldPosition:FieldPosition, topView:UIView, topViewParams : NSDictionary?, isIndependentField: Bool, inview: UIView, horizontalGroupCount:NSInteger){
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        
        
        let container = UIView.init()
        //        container.clipsToBounds = true;
        //        container.backgroundColor = UIColor.green
        container.translatesAutoresizingMaskIntoConstraints = false
        let Width = params.value(forKey: Constants.key_Width) as! String
        let Padding = convertPostions(position: params.value(forKey: Constants.key_Padding) as! String)
        let Margin = convertPostions(position: params.value(forKey: Constants.key_Margin) as! String)
        let Align = params.value(forKey: Constants.key_Align) as! String
        let imageUrl = params.value(forKey: Constants.key_ImageUrl) as! String
        
        var topViewMargin = ""
        if topViewParams != nil{
            topViewMargin = convertPostions(position: topViewParams?.value(forKey: Constants.key_Margin) as! String)
        }
        if isIndependentField {
            Utility.setAutolayoutToIndependentField(toView: container, inView: inview, attributes: Margin, width: CGFloat((Width as NSString).doubleValue), alignment: Align, fieldPosition: fieldPosition)
        }else{
            Utility.setAutolayout(toView: container, inView: inview, attributes: Margin, fieldPosition: fieldPosition,topView: topView,topViewAttibutes: topViewMargin, width: CGFloat((Width as NSString).doubleValue), alignment: Align);
        }
        Utility.setboarderToView(view: container, fromParams: params,fillBg: false)
        Utility.setAutolayout(toView: imageView, inView: container, attributes: Padding, fieldPosition: FieldPosition.None,topView: topView,topViewAttibutes: "nil", width:0.0,alignment: "nil");
        if isIndependentField {
            self.uiIndependsFields.append(container)
        }else{
            self.uiFields.append(container)
        }
        
        let activityIndicator = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.medium)
        activityIndicator.hidesWhenStopped = true
        //        activityIndicator.tintColor = UIColor.brown
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(activityIndicator)
        let centerYContraints = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: container, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        let centerXContraints = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: container, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        centerXContraints.isActive = true
        centerYContraints.isActive = true
        
        let activityVerticalVisulaString : String = "V:|-[activityIndicator]-|"
        let mediaViews : [String : Any] = ["activityIndicator":activityIndicator,"container":container]
        let activityHorizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "|-[activityIndicator]-|", options: [], metrics: nil, views: mediaViews)
        let activityVerticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: activityVerticalVisulaString, options: [], metrics: nil, views: mediaViews)
        NSLayoutConstraint.activate(activityHorizontalConstraint)
        NSLayoutConstraint.activate(activityVerticalConstraint)
        
        downloadImageWithUrl(urlString: imageUrl, imageView: imageView,activityIndicator: activityIndicator, resizeImageView: true)
    }
    func downloadImageWithUrl(urlString : String, imageView:UIImageView, activityIndicator: UIActivityIndicatorView, resizeImageView:Bool){
        if urlString.count == 0 {
            return
        }
        var task: URLSessionDownloadTask!
        var session: URLSession!
        session = URLSession.shared
        task = URLSessionDownloadTask()
        if (resizeImageView && P5SDKManager.sharedInstance.cache.object(forKey: urlString as AnyObject) != nil){
            // 2
            // Use cache
            print("Cached image used, no need to download it")
            let image = P5SDKManager.sharedInstance.cache.object(forKey: urlString as AnyObject) as? UIImage
            if resizeImageView {
                imageView.layoutIfNeeded()
                let height = self.getHeightForWidth(width: imageView.frame.size.width, size: (image?.size)!)
                self.addHeightContraint(toView: imageView, height: height)
                let imageContainer = imageView.superview;
                imageContainer?.clipsToBounds = true;
            }else{
                
                //                imageView.invalidateIntrinsicContentSize()
                //                imageView.layoutIfNeeded()
                //                let height = imageView.frame.size.height
                //                self.addHeightContraint(toView: imageView, height: height)
            }
            imageView.image = image
            activityIndicator.stopAnimating()
            activityIndicator.removeConstraints(activityIndicator.constraints)
            activityIndicator.removeFromSuperview()
        }else{
            // 3
            let url:URL! = URL(string: urlString)
            task = session.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                if let data = try? Data(contentsOf: url){
                    // 4
                    DispatchQueue.main.async(execute: { () -> Void in
                        // 5
                        // Before we assign the image, check whether the current cell is visible
                        let img:UIImage! = UIImage(data: data)
                        if resizeImageView {
                            let height = self.getHeightForWidth(width: imageView.frame.size.width, size: (img?.size)!)
                            imageView.image = img
                            self.addHeightContraint(toView: imageView, height: height)
                            let imageContainer = imageView.superview;
                            imageContainer?.clipsToBounds = true;
                        }else{
                            //                            imageView.invalidateIntrinsicContentSize()
                            //                            imageView.layoutIfNeeded()
                            //                            let height = imageView.frame.size.height
                            imageView.image = img
                            //                            self.addHeightContraint(toView: imageView, height: height)
                        }
                        
                        P5SDKManager.sharedInstance.cache.setObject(img, forKey: urlString as AnyObject)
                        activityIndicator.stopAnimating()
                        activityIndicator.removeConstraints(activityIndicator.constraints)
                        activityIndicator.removeFromSuperview()
                    })
                }
            })
            task.resume()
        }
    }
    func addHeightContraint(toView : UIView, height: CGFloat){
        let metrics = ["height": height]
        let views : [String : Any] = ["toView":toView]
        let heightConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:[toView(height)]", options: [], metrics: metrics, views: views)
        
        NSLayoutConstraint.activate(heightConstraint)
    }
    func getHeightForWidth(width: CGFloat, size: CGSize) -> CGFloat{
        var requiredHeight  = 0.0
        //        let aspectRatio = size.width/size.height;
        requiredHeight = Double((width  * size.height)/size.width);
        return CGFloat(requiredHeight);
    }
    func drawCountDownViewParams(params : NSDictionary, fieldPosition:FieldPosition, topView:UIView, topViewParams : NSDictionary?, isIndependentField: Bool, inview: UIView, horizontalGroupCount:NSInteger){
        let countDownTimer = P5CountDownView()
        let Margin = convertPostions(position: params.value(forKey: Constants.key_Margin) as! String)
        let Width = params.value(forKey: Constants.key_Width) as! String
        let Align = params.value(forKey: Constants.key_Align) as! String
        
        var topViewMargin = ""
        if topViewParams != nil{
            topViewMargin = convertPostions(position: topViewParams?.value(forKey: Constants.key_Margin) as! String)
        }
        if  isIndependentField {
            Utility.setAutolayoutToIndependentField(toView: countDownTimer, inView: inview, attributes: Margin, width: CGFloat((Width as NSString).doubleValue), alignment: Align, fieldPosition: fieldPosition)
        }else{
            Utility.setAutolayout(toView: countDownTimer, inView: inview, attributes: Margin, fieldPosition: fieldPosition,topView: topView,topViewAttibutes: topViewMargin, width:CGFloat((Width as NSString).doubleValue) , alignment: Align);
        }
        Utility.setboarderToView(view: countDownTimer, fromParams: params, fillBg: true)
        if isIndependentField {
            self.uiIndependsFields.append(countDownTimer)
        }else{
            self.uiFields.append(countDownTimer)
        }
        countDownTimer.model = params;
        
    }
    
    func drawRatingBarParams(params : NSDictionary, fieldPosition:FieldPosition, topView:UIView, topViewParams : NSDictionary?, isIndependentField: Bool, inview: UIView, horizontalGroupCount:NSInteger){
        let ratingBar = VFRatingBar()
        let Margin = convertPostions(position: params.value(forKey: Constants.key_Margin) as! String)
        let Width = params.value(forKey: Constants.key_Width) as! String
        let Align = params.value(forKey: Constants.key_Align) as! String
        
        var topViewMargin = ""
        if topViewParams != nil{
            topViewMargin = convertPostions(position: topViewParams?.value(forKey: Constants.key_Margin) as! String)
        }
        if isIndependentField{
            Utility.setAutolayoutToIndependentField(toView: ratingBar, inView: inview, attributes: Margin, width: CGFloat((Width as NSString).doubleValue), alignment: Align, fieldPosition: fieldPosition)
        }else{
            Utility.setAutolayout(toView: ratingBar, inView: inview, attributes: Margin, fieldPosition: fieldPosition,topView: topView,topViewAttibutes: topViewMargin, width:CGFloat((Width as NSString).doubleValue) , alignment: Align);
        }
        Utility.setboarderToView(view: ratingBar, fromParams: params, fillBg: true)
        if isIndependentField {
            self.uiIndependsFields.append(ratingBar)
        }else{
            self.uiFields.append(ratingBar)
        }
    }
    
    
    
    //Text field delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func resignFirstResponderInView(inView:UIView){
        for view in inView.subviews{
            if view.isFirstResponder {
                view.resignFirstResponder()
            }else{
                resignFirstResponderInView(inView: view)
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        resignFirstResponderInView(inView: self)
        /*if let touch = touches.first {
         let currentPoint = touch.location(in: self)
         if formView.frame.contains(currentPoint){
         // Touches the banner
         
         P5SDKManager.updateFormResponse(mobileFormID: MobilePushId!, formResponse: "Banner", bannerView: "0", bannerClick: "1", bannerClose: "0", btnName: "",geofenceName: "",beaconName: "")
         }
         }*/
    }
    func validateMandatoryFields() -> (Bool, String){
        var valid = true
        var errorMsg = ""
        if self.fields.count > 0 {
            for index in 0...self.fields.count-1{
                let field = self.fields[index]
                let Mandatory = field.value(forKey: Constants.key_Mandatory) as! String
                if Mandatory == "1" {
                    let uiFieldView = self.uiFields[index]
                    if uiFieldView is P5BaseFromView {
                        let view = uiFieldView as! P5BaseFromView
                        if !view.isFieldValid() {
                            valid = false
                            let name = field.value(forKey: Constants.key_Name) as! String
                            errorMsg = name + " is invalid"
                            break
                        }
                    }
                }
            }
        }
        
        if valid && self.independentsFields.count > 0{
            for index in 0...self.independentsFields.count-1{
                let field = self.independentsFields[index]
                let Mandatory = field.value(forKey: Constants.key_Mandatory) as! String
                if Mandatory == "1" {
                    let uiFieldView = self.uiIndependsFields[index]
                    if uiFieldView is P5BaseFromView {
                        let view = uiFieldView as! P5BaseFromView
                        if !view.isFieldValid() {
                            valid = false
                            let name = field.value(forKey: Constants.key_Name) as! String
                            errorMsg = name + " is invalid"
                            break
                        }
                    }
                }
            }
        }
        
        return (valid, errorMsg)
    }
    
    func getIputValues() -> String {
        var response : String = ""
        var textFieldCount = 0
        var array : Array<String> = Array()
        if self.fields.count > 0 {
            for index in 0...self.fields.count-1{
                let field = self.fields[index]
                let uiFieldView = self.uiFields[index]
                if uiFieldView is P5BaseFromView {
                    let view = uiFieldView as! P5BaseFromView
                    let name = field.value(forKey: Constants.key_Name) as! String
                    if uiFieldView is P5TextFieldView {
                        let field = uiFieldView as! P5TextFieldView
                        var fieldValue = name + "#"
                        fieldValue = fieldValue + String(textFieldCount)
                        fieldValue = fieldValue + "$~" + field.fieldValue()
                        array.append(fieldValue);
                        textFieldCount = textFieldCount + 1
                    }
                    else{
                        var fieldValue : String
                        fieldValue = name + "~" + view.fieldValue()
                        array.append(fieldValue);
                    }
                }else{
                    let type = field.value(forKey: Constants.key_Type) as! String
                    if type == "Cb" {
                        for tfield in uiFieldView.subviews{
                            if tfield is P5CheckBox {
                                let checkbox  = tfield as! P5CheckBox
                                let name = field.value(forKey: Constants.key_Name) as! String
                                var fieldValue : String
                                if checkbox.isSelected {
                                    fieldValue = name + "~" + name
                                }else{
                                    fieldValue = name + "~ "
                                }
                                array.append(fieldValue);
                            }
                        }
                    }
                }
            }
            if self.independentsFields.count > 0 {
                for index in 0...self.independentsFields.count-1{
                    let field = self.independentsFields[index]
                    let uiFieldView = self.uiIndependsFields[index]
                    if uiFieldView is P5BaseFromView {
                        let view = uiFieldView as! P5BaseFromView
                        let name = field.value(forKey: Constants.key_Name) as! String
                        if uiFieldView is P5TextFieldView {
                            let field = uiFieldView as! P5TextFieldView
                            var fieldValue = name + "#"
                            fieldValue = fieldValue + String(textFieldCount)
                            fieldValue = fieldValue + "$~" + field.fieldValue()
                            array.append(fieldValue);
                            textFieldCount = textFieldCount + 1
                        }else if( uiFieldView is P5CheckBox){
                            let checkbox  = uiFieldView as! P5CheckBox
                            var fieldValue : String
                            if checkbox.isSelected {
                                fieldValue = name + "~" + name
                            }else{
                                fieldValue = name + "~ "
                            }
                            array.append(fieldValue);
                        }else{
                            var fieldValue : String
                            fieldValue = name + "~" + view.fieldValue()
                            array.append(fieldValue);
                        }
                    }else{
                        let type = field.value(forKey: Constants.key_Type) as! String
                        if type == "Cb" {
                            for tfield in uiFieldView.subviews{
                                if tfield is P5CheckBox {
                                    let checkbox  = tfield as! P5CheckBox
                                    let name = field.value(forKey: Constants.key_Name) as! String
                                    var fieldValue : String
                                    if checkbox.isSelected {
                                        fieldValue = name + "~" + name
                                    }else{
                                        fieldValue = name + "~ "
                                    }
                                    array.append(fieldValue);
                                }
                            }
                        }
                    }
                }
            }
        }
        response = " " + array.joined(separator: " ^ ")
        print("response" + response)
        return response
        
    }
    func performActionForBtn(params : NSDictionary){
        let btnName = params[Constants.key_Name] as? String;
        let (isvalid, errorMsg) = validateMandatoryFields()
        if  isvalid {
            //            let action = params[Constants.key_Action] as? String;
            //            if action?.characters.count == 0 {
            //                formCloseTapped()
            //                return;
            //
            //            }
            //            let actionType : Actions = Actions(rawValue: action!)!
            //            let Redirect = params[Constants.key_Redirect] as? String
            //            let Parameter = params[Constants.key_Parameter] as? String
            //            let Message = params[Constants.key_Message] as? String
            //
            //            let info : Dictionary<String, String> = [Constants.key_Redirect : Redirect!,
            //                                                     Constants.key_Parameter : Parameter!,
            //                                                     Constants.key_Message : Message!]
            //            actionType.rawValue = action
            
            let action = params[Constants.key_Action] as? String;
            //            if action?.characters.count == 0 {
            //                removeDialog()
            //                return;
            //            }
            let actionType : Actions = Actions(rawValue: action!)!
            if actionType == .Form && formType == "Form"{
                let message : String = (params[Constants.key_Message] as? String)!
                P5SDKManager.updateFormResponse(mobileFormID: MobilePushId!, formResponse: self.getIputValues(), bannerView: "0", bannerClick: "1", bannerClose: "0", btnName:"",geofenceName: "",beaconName: "", screenName: screenName,widgetName: widgetName!)
//                P5SDKManager.sharedInstance.currentVC?.showToast(message: message)
                removeDialog()
            }else if actionType == .None {
                let message : String = (params[Constants.key_Message] as? String)!
                P5SDKManager.updateFormResponse(mobileFormID: MobilePushId!, formResponse: formType, bannerView: "0", bannerClick: "1", bannerClose: "0", btnName: btnName!,geofenceName: "",beaconName: "", screenName: screenName,widgetName: widgetName!)
//                P5SDKManager.sharedInstance.currentVC?.showToast(message: message)
                //                P5SDKManager.handleActions(params: params as! Dictionary<String, String>, dataModel: self.dataModel as! Dictionary <String, Any>, eventType: eventType)
            }
            else{
                P5SDKManager.updateFormResponse(mobileFormID: MobilePushId!, formResponse: formType, bannerView: "0", bannerClick: "1", bannerClose: "0", btnName: btnName!,geofenceName: "",beaconName: "", screenName: screenName,widgetName: widgetName!)
                P5SDKManager.handleActions(params: params as! Dictionary<String, String>, dataModel: self.dataModel as! Dictionary <String, Any>, eventType: eventType)
                removeDialog()
            }
            
            
        }else{
            P5SDKManager.updateFormResponse(mobileFormID: MobilePushId!, formResponse: formType, bannerView: "0", bannerClick: "1", bannerClose: "0", btnName: btnName!,geofenceName: "",beaconName: "", screenName: screenName,widgetName: widgetName!)
            let alertView = UIAlertView.init(title: "Error", message: errorMsg, delegate: nil, cancelButtonTitle: "Ok")
            alertView.show()
        }
        //        let action  = params.value(forKey: Constants.key_Action) as? String
        //        switch action {
        //        case ?"Form","Dismiss":
        //            formCloseTapped()
        //        default:
        //            formCloseTapped()
        //        }
    }
    
    func convertPostions(position : String) -> String{
        //        var newPostion : String
        //        let array = position.components(separatedBy: ",")
        //        if array.count == 4 {
        //            newPostion = array[1] + "," + array[2] + "," + array[3] + "," + array[0]
        //        }else{
        //            newPostion = position
        //        }
        return position;
    }
    
    func convertLayoutPostions(position : String) -> String{
        var newPostion : String
        let array = position.components(separatedBy: ",")
        if array.count == 4 {
            newPostion = array[3] + "," + array[0] + "," + array[1] + "," + array[2]
        }else{
            newPostion = position
        }
        return newPostion;
    }
}
