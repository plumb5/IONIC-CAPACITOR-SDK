//
//  P5NotificationDetailView.swift
//  Plumb5SDK
//
//  Created by Shahid Akhtar Shaikh on 7/10/17.
//  Copyright © 2017 Plumb5. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class P5NotificationDetailView: UIView {
    let eventType :String = "Custom-Push-Event"
    let activityIndicator = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.medium)
    let btnPlayPause = UIButton.init(type: .custom)
    var player : AVPlayer?
    var formView:UIView!
    var viewContainer : UIView!
    var extraButtonView :UIView!
    var mainViewContainer : UIView!
    var MobilePushId :Any!
    var widgetName : String!
    var geofenceName : String = ""
    var beaconName : String = ""
    var userInfo: Dictionary<String, Any> = [:]{
        didSet{
            drawNotificationBanner()
        }
    }
    func drawNotificationBanner(){
        let pushId = userInfo[Constants.key_MobilePushId]
        MobilePushId = pushId
        if (userInfo["WidgetName"] != nil){
            widgetName = userInfo["WidgetName"] as? String
        }else{
            widgetName = ""
        }
        //        if pushId is String{
        //            MobilePushId = pushId as! String
        //        }else{
        //            MobilePushId = String
        //        }
        self.backgroundColor = UIColor.init(white: 1.0, alpha: 0.3)
        Utility.isDynamicHeight = true
        formView = UIView.init()
        formView.translatesAutoresizingMaskIntoConstraints = false
        formView.clipsToBounds = true
        
        viewContainer = UIView()
        extraButtonView = UIView()
        mainViewContainer = UIView()
        extraButtonView.backgroundColor = UIColor.clear
        mainViewContainer.backgroundColor = UIColor.clear
        mainViewContainer.translatesAutoresizingMaskIntoConstraints = false
        mainViewContainer.clipsToBounds = true
        
        let Padding = "0,40,0,0"
        let views : [String : Any] = ["formView":formView,"mainViewContainer" : mainViewContainer]
        self.addSubview(mainViewContainer)
        var horizontalVisualString : String
        var metrics : [String:Any] = [:]
        horizontalVisualString = "|-7-[mainViewContainer]-7-|"
        let verticalVisualString = "V:|-(>=7)-[mainViewContainer]-(>=7)-|"
        
        let body = userInfo[Constants.key_Message] as? String
        let title = userInfo[Constants.key_Title] as? String
        
        //        body = "Abc"
        
        let attachmentUrl = userInfo[Constants.key_ImageUrl] as? String
        
        let verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat:verticalVisualString, options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(verticalConstraint)
        
        let  centerYContraints = NSLayoutConstraint(item: mainViewContainer, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        centerYContraints.isActive = true
        
        let centerXContraints = NSLayoutConstraint(item: mainViewContainer, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        centerXContraints.isActive = true
        let horizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: horizontalVisualString, options: [], metrics: metrics, views: views)
        NSLayoutConstraint.activate(horizontalConstraint)
        
        let VerticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: verticalVisualString, options: [], metrics: metrics, views: views)
        NSLayoutConstraint.activate(VerticalConstraint)
        
        formView.backgroundColor = UIColor.white
        
        formView.layer.cornerRadius = 10.0
        formView.layer.borderColor = UIColor.clear.cgColor
        
        
        //        let BgImage = display.value(forKey: "BgImage") as! String
        //        if BgImage != nil && BgImage.characters.count == 0{
        //            let bgImageView = UIImageView()
        //            bgImageView.contentMode = .scaleToFill
        //            bgImageView.clipsToBounds = true
        //
        //            bgImageView.frame = formView.frame
        //            bgImageView.translatesAutoresizingMaskIntoConstraints = false
        //            formView.addSubview(bgImageView)
        //            let ImageViews : [String : Any] = ["bgImageView":bgImageView]
        //            let imageHorizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "|-0-[bgImageView]-0-|", options: .directionLeadingToTrailing, metrics: metrics, views: ImageViews)
        //            let imageVerticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[bgImageView]-0-|", options: .directionLeadingToTrailing, metrics: metrics, views: ImageViews)
        //            NSLayoutConstraint.activate(imageHorizontalConstraint)
        //            NSLayoutConstraint.activate(imageVerticalConstraint)
        //
        //            downloadImageWithUrl(urlString: BgImage, imageView: bgImageView)
        //        }
        Utility.setAutolayout(toView: formView, inView: mainViewContainer, attributes: "0,0,0,0", fieldPosition: FieldPosition.VerticallyFirst, topView: UIView(), topViewAttibutes: "nil", width: 0, alignment: "nil")
        Utility.setAutolayout(toView: viewContainer, inView: formView, attributes: Padding, fieldPosition: FieldPosition.None, topView: UIView(), topViewAttibutes: "nil", width: 0, alignment: "nil")
        Utility.setAutolayout(toView: extraButtonView, inView: mainViewContainer, attributes: "0,5,0,0", fieldPosition: FieldPosition.VerticallyLast, topView: viewContainer, topViewAttibutes: "nil", width: 0, alignment: "nil")
        
        let btnClose = UIButton.init(type: .custom)
        btnClose.setTitleColor(UIColor.blue, for: .normal)
        let frameWorkBundle = Bundle(for: type(of: self))
        let imgClose = UIImage.init(named: "ic_close", in: frameWorkBundle, compatibleWith: nil);
        btnClose.setImage(imgClose, for: .normal)
        self.addSubview(btnClose)
        btnClose.translatesAutoresizingMaskIntoConstraints = false
        btnClose.addTarget(self, action: #selector(formCloseTapped), for: .touchUpInside)
        
        metrics = ["padding": -45.0]
        let btnViews : [String : Any] = ["btnClose":btnClose,"formView":formView!]
        let btnHorizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "[formView]-padding-[btnClose(40)]", options: [], metrics: metrics, views: btnViews)
        let btnVerticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:[btnClose(40)]-padding-[formView]", options: [], metrics: metrics, views: btnViews)
        NSLayoutConstraint.activate(btnHorizontalConstraint)
        NSLayoutConstraint.activate(btnVerticalConstraint)
        var topView : UIView?
        if attachmentUrl != nil && (attachmentUrl?.count)! > 0{
            var mediaType =  userInfo[Constants.key_MediaType] as? String
            if mediaType == nil {
                mediaType = "image"
            }
            let mediaView = UIView()
            mediaView.translatesAutoresizingMaskIntoConstraints = false
            self.viewContainer.addSubview(mediaView)
            var verticalVisulaStringForMedia : String = "V:|-[mediaView]"
            let mediaViews : [String : Any] = ["mediaView":mediaView,"formView":formView]
            let mediaHorizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "|[mediaView]|", options: [], metrics: metrics, views: mediaViews)
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            mediaView.addSubview(activityIndicator)
            switch mediaType! {
            case "image","gif":
                let activityVerticalVisulaString : String = "V:|-[activityIndicator]-|"
                let activityViews : [String : Any] = ["activityIndicator":activityIndicator,"mediaView":mediaView]
                let activityHorizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "|-[activityIndicator]-|", options: [], metrics: nil, views: activityViews)
                let activityVerticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: activityVerticalVisulaString, options: [], metrics: nil, views: activityViews)
                NSLayoutConstraint.activate(activityHorizontalConstraint)
                NSLayoutConstraint.activate(activityVerticalConstraint)
                drawImageWithParams(imageUrl: attachmentUrl!,inView: mediaView)
            case "video","audio":
                createAVPlayerWithParams(mediaLink: attachmentUrl!, inView: mediaView)
                if mediaType == "audio" {
                    verticalVisulaStringForMedia = "V:|[mediaView(70)]"
                }else{
                    verticalVisulaStringForMedia = "V:|[mediaView(200)]"
                }
                
                createPausePlayButton(inView: mediaView)
                let centerYContraints = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: mediaView, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
                let centerXContraints = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: mediaView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
                centerXContraints.isActive = true
                centerYContraints.isActive = true
            default:
                break
            }
            let mediaVerticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: verticalVisulaStringForMedia, options: [], metrics: metrics, views: mediaViews)
            NSLayoutConstraint.activate(mediaHorizontalConstraint)
            NSLayoutConstraint.activate(mediaVerticalConstraint)
            topView = mediaView
        }
        var fieldPosition : FieldPosition = .VerticallyMiddle
        if topView == nil{
            topView = UIView()
            fieldPosition = .VerticallyFirst
        }
        if title != nil && (title?.count)! > 0{
            let titleLabl = drawText(text: title!,topView: topView!, position: fieldPosition, Padding: "15,10,10,5")
            topView = titleLabl
            titleLabl.font = UIFont.boldSystemFont(ofSize: 17)
            fieldPosition = .VerticallyMiddle
        }else{
            if attachmentUrl == nil{
                fieldPosition = .None
            }else{
                fieldPosition = .VerticallyMiddle
            }
        }
        let bodyLbl = drawText(text: body!,topView: topView!, position: fieldPosition, Padding: "15,3,10,20")
        drawText(text: "  ",topView: bodyLbl, position: .VerticallyLast, Padding: "15,3,10,20")
        P5SDKManager.updateFormResponse(mobileFormID: MobilePushId!, formResponse: "Push", bannerView: "1", bannerClick: "0", bannerClose: "0", btnName: "",geofenceName: geofenceName,beaconName: beaconName,screenName: "", widgetName: widgetName!)
        guard let extraBtns = userInfo["ExtraButtons"] as? String
            else{
                return;
        }
        createExtraButtons(extraBtns: extraBtns)
    }
    func createExtraButtons(extraBtns : String){
        if extraBtns.count == 0{
            return
        }
        let btns = extraBtns.components(separatedBy: "|")
        //        btns.append(contentsOf: btns)
        if btns.count == 1{
            addHeightContraint(toView: extraButtonView, height: 60)
        }
        var array : Array<P5ExtraButton> = Array()
        var index = 0
        while index < btns.count {
            let button = P5ExtraButton()
            button.backgroundColor = UIColor.white
            
            button.layer.cornerRadius = 10.0
            button.layer.borderColor = UIColor.clear.cgColor
            button.btnPrams = btns[index]
            let attributes = "0,5,0,5"
            var topView : UIView;
            if index == 0{
                topView = UIView()
            }else{
                topView = array[index - 1]
            }
            button.btnTapHandler = { (action : String, params : String) in
                self.performExtrabtnAction(action: action, params: params)
            }
            
            Utility.setAutolayout(toView: button, inView: extraButtonView, attributes: attributes, fieldPosition: Utility.getVerticalFieldPosition(index: index, totalCount: btns.count), topView: topView, topViewAttibutes: attributes, width: 0, alignment: "nil")
            array.append(button)
            index += 1
        }
    }
    func addHeightContraint(toView : UIView, height: CGFloat){
        let metrics = ["height": height]
        let views : [String : Any] = ["toView":toView]
        let heightConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:[toView(height)]", options: [], metrics: metrics, views: views)
        
        NSLayoutConstraint.activate(heightConstraint)
    }
    func createPausePlayButton(inView: UIView){
        btnPlayPause.isHidden = true
        btnPlayPause.translatesAutoresizingMaskIntoConstraints = false
        btnPlayPause.setTitleColor(UIColor.blue, for: .normal)
        let frameWorkBundle = Bundle(for: type(of: self))
        let imgPlay = UIImage.init(named: "play", in: frameWorkBundle, compatibleWith: nil);
        let imgPause = UIImage.init(named: "pause", in: frameWorkBundle, compatibleWith: nil);
        btnPlayPause.setImage(imgPlay, for: .normal)
        btnPlayPause.setImage(imgPause, for: .selected)
        inView.addSubview(btnPlayPause)
        btnPlayPause.translatesAutoresizingMaskIntoConstraints = false
        btnPlayPause.addTarget(self, action: #selector(playPauseTapped), for: .touchUpInside)
        
        let metrics = ["padding": 15.0]
        let btnViews : [String : Any] = ["btnPlayPause":btnPlayPause,"inView":inView]
        let btnHorizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "[btnPlayPause(40)]", options: [], metrics: metrics, views: btnViews)
        let btnVerticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:[btnPlayPause(40)]", options: [], metrics: metrics, views: btnViews)
        NSLayoutConstraint.activate(btnHorizontalConstraint)
        NSLayoutConstraint.activate(btnVerticalConstraint)
        
        let centerYContraints = NSLayoutConstraint(item: btnPlayPause, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: inView, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        let centerXContraints = NSLayoutConstraint(item: btnPlayPause, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: inView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        centerXContraints.isActive = true
        centerYContraints.isActive = true
    }
    func downloadImageWithUrl(urlString : String, imageView:UIImageView){
        if urlString.count == 0 {
            return
        }
        var task: URLSessionDownloadTask!
        var session: URLSession!
        session = URLSession.shared
        task = URLSessionDownloadTask()
        if (P5SDKManager.sharedInstance.cache.object(forKey: urlString as AnyObject) != nil){
            // 2
            // Use cache
            print("Cached image used, no need to download it")
            imageView.image = P5SDKManager.sharedInstance.cache.object(forKey: urlString as AnyObject) as? UIImage
            imageView.layoutIfNeeded()
            let height = self.getHeightForWidth(width: imageView.frame.size.width, size: (imageView.image?.size)!)
            self.addHeightContraint(toView: imageView, height: height)
            stopActivityIndicator()
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
                        self.stopActivityIndicator()
                        imageView.image = img
                        let height = self.getHeightForWidth(width: imageView.frame.size.width, size: img.size)
                        self.addHeightContraint(toView: imageView, height: height)
                        P5SDKManager.sharedInstance.cache.setObject(img, forKey: urlString as AnyObject)
                        
                    })
                }
            })
            task.resume()
        }
    }
    
    func getHeightForWidth(width: CGFloat, size: CGSize) -> CGFloat{
        var requiredHeight  = 0.0
        //        let aspectRatio = size.width/size.height;
        requiredHeight = Double(((self.frame.size.width - 14) * size.height)/size.width);
        return CGFloat(requiredHeight);
    }
    @objc func formCloseTapped() {
        self.removeFromSuperview()
        P5SDKManager.updateFormResponse(mobileFormID: MobilePushId!, formResponse: "Push", bannerView: "0", bannerClick: "0", bannerClose: "1", btnName: "",geofenceName:geofenceName,beaconName: beaconName, screenName: "", widgetName: widgetName!)
        removeAllOberser()
    }
    @objc func playPauseTapped() {
        btnPlayPause.isSelected = !btnPlayPause.isSelected
        if btnPlayPause.isSelected{
            player?.play()
            
        }else{
            player?.pause()
            
        }
    }
    func removeAllOberser(){
        if player != nil{
            player?.removeObserver(self, forKeyPath: "currentItem.loadedTimeRanges")
        }
    }
    func drawImageWithParams(imageUrl : String, inView:UIView){
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        
        
        let container = UIView.init()
        container.translatesAutoresizingMaskIntoConstraints = false
        let Padding = "0,0,0,0"
        let Margin = "0,0,0,0"
        let Align = "Center"
        
        let topViewMargin = ""
        //        Utility.setAutolayout(toView: container, inView: inView, attributes: Margin, fieldPosition: .VerticallyFirst,topView: UIView(),topViewAttibutes: topViewMargin, width: 0.0, alignment: Align);
        Utility.setAutolayout(toView: imageView, inView: inView, attributes: Padding, fieldPosition: FieldPosition.None,topView: UIView(),topViewAttibutes: "nil", width:0.0,alignment: "nil");
        activityIndicator.startAnimating()
        downloadImageWithUrl(urlString: imageUrl, imageView: imageView)
    }
    func createAVPlayerWithParams(mediaLink : String, inView:UIView){
        player = AVPlayer(url: URL.init(string: mediaLink)!)
        
        //        let avPlayerVC = AVPlayerViewController()
        //        avPlayerVC.player = player
        //        inView.addSubview(avPlayerVC.view)
        //        avPlayerVC.view.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width - 14, height: 200)
        //        avPlayerVC.showsPlaybackControls = true
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width - 14, height: 200)
        inView.layer.addSublayer(playerLayer)
        player?.play()
        player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        
        activityIndicator.startAnimating()
    }
    func drawText(text: String, topView: UIView, position: FieldPosition, Padding:String) -> UILabel{
        let lable = UILabel();
        lable.text = text;
        lable.numberOfLines = 0
        let Size = "17"
        let Style = "normal"
        
        
        let Orientation = "Left"
        lable.textColor = UIColor.black
        
        Utility.setFontTo(view: lable, size: Size, style: Style, align: Orientation);
        
        let labelContainer = UIView.init()
        labelContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let topViewMargin = ""
        labelContainer.backgroundColor = UIColor.clear
        
        //        Utility.setAutolayout(toView: labelContainer, inView: viewContainer, attributes: "", fieldPosition: .VerticallyLast,topView: topView, topViewAttibutes: topViewMargin, width: 0.0,alignment: "Left");
        Utility.setAutolayout(toView: lable, inView: viewContainer, attributes: Padding,fieldPosition: position, topView: topView,topViewAttibutes: "nil", width:0.0, alignment: "nil");
        return lable
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if (keyPath == "currentItem.loadedTimeRanges"){
            let timeRange = player?.currentItem?.loadedTimeRanges.first as? CMTimeRange
            guard let duration = timeRange?.duration else { return }
            let timeLoaded = Int(duration.value) / Int(duration.timescale)
            if timeLoaded > 0{
                stopActivityIndicator()
                //                player.removeObserver(self, forKeyPath: "currentItem.loadedTimeRanges")
            }
            if timeLoaded > 3{
                btnPlayPause.isHidden = false
                btnPlayPause.isSelected = true
            }
            //            if player.status == .readyToPlay{
            //                print("ready")
            //
            //            }else if player.status == .failed{
            //                print("failed")
            //                stopActivityIndicator()
            //            }
        }
    }
    @objc func playerDidFinishPlaying(note: NSNotification){
        //Called when player finished playing
        btnPlayPause.isHidden = false
        btnPlayPause.isSelected = false
        let timeScale = player?.currentItem?.asset.duration.timescale;
        let seconds : Float64 = 0.0
        let time = CMTimeMakeWithSeconds(seconds, preferredTimescale: timeScale!)
        player?.seek(to: time)
    }
    func stopActivityIndicator(){
        activityIndicator.stopAnimating()
        activityIndicator.removeConstraints(activityIndicator.constraints)
        activityIndicator.removeFromSuperview()
        
    }
    func performExtrabtnAction(action : String, params : String){
        
        var actionType : Actions
        switch action {
        case "0":
            actionType = .Dismiss
        case "1":
            actionType = .RedirectToScreen
        case "2":
            actionType = .DeepLinkingURL
        case "3":
            actionType = .ExternalURL
        case "4":
            actionType = .Copy
        case "5":
            actionType = .Call
        case "6":
            actionType = .Share
        case "7":
            actionType = .RemindLater
        case "8":
            actionType = .EventTracking
        case "9":
            actionType = .TextMessage
        default:
            actionType = .Dismiss
        }
        P5SDKManager.handleAction(actionType: actionType, redirectUrl: params, parameters: "", message: "", dataModel: userInfo, eventType: eventType)
        self.removeFromSuperview()
        removeAllOberser()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            if formView.frame.contains(currentPoint){
                // Touches the banner
                
                P5SDKManager.updateFormResponse(mobileFormID: MobilePushId!, formResponse: "Push", bannerView: "0", bannerClick: "1", bannerClose: "0", btnName: "",geofenceName: geofenceName,beaconName: beaconName, screenName: "", widgetName: widgetName!)
                let RedirectTo = userInfo[Constants.key_RedirectTo] as! String
                let DeepLinkUrl = userInfo[Constants.key_DeepLinkUrl] as! String
                let ExternalUrl = userInfo[Constants.key_ExternalUrl] as! String
                let Parameters = userInfo[Constants.key_Parameters] as! String
                var actionType : Actions = .Dismiss
                var redirectUrl : String = ""
                if  RedirectTo.count > 0{
                    actionType = .RedirectToScreen
                    redirectUrl = RedirectTo
                }else if DeepLinkUrl.count > 0{
                    actionType = .DeepLinkingURL
                    redirectUrl = DeepLinkUrl
                }else if ExternalUrl.count > 0{
                    actionType = .ExternalURL
                    redirectUrl = ExternalUrl
                }
                if redirectUrl.count > 0{
                    self.removeFromSuperview()
                    removeAllOberser()
                    P5SDKManager.handleAction(actionType: actionType, redirectUrl: redirectUrl, parameters: Parameters,message: "", dataModel: [:], eventType: eventType)
                }
            }
        }
    }
}
