//
//  P5FixBanner.swift
//  Plumb5SDK
//
//  Created by Shahid Akhtar Shaikh on 8/1/17.
//  Copyright © 2017 Plumb5. All rights reserved.
//

import Foundation
import UIKit
public protocol P5BannerDelegate : AnyObject{
    func bannerLoaded()
    func bannerRemoved()
}
public class P5BannerView : UIView{
    @objc var widgetName : String!
    @objc var screenName:String = ""
    @objc var imageView : UIImageView!
    @objc var closeBtn : UIButton!
    weak var delegate: P5BannerDelegate!
    @objc var MobilePushId : Any!
    @objc var formView:UIView!
    @objc var viewContainer : UIView!
    @objc var activityIndicator : UIActivityIndicatorView?
    
    @objc var formContent : NSDictionary = [:]{
        didSet{
            refreshUI()
        }
    }
    public func setDelagate(delegate : P5BannerDelegate){
        self.delegate = delegate
    }
    @objc var dataModel:NSDictionary = [:]{
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
            }
        }
    }
    @objc func refreshUI(){
        let pushId = dataModel[Constants.key_MobileFormId]
        MobilePushId = pushId
        widgetName = dataModel["WidgetName"] as? String
        
        let Image = formContent["Image"] as! String
        let bgImageView = UIImageView()
        bgImageView.contentMode = .scaleToFill
        bgImageView.clipsToBounds = true
        
        
        bgImageView.backgroundColor = UIColor.clear
      
        Utility.setAutolayout(toView: bgImageView, inView: self, attributes: "0,0,0,0", fieldPosition: FieldPosition.None, topView: UIView(), topViewAttibutes: "0,0,0,0", width: 0.0, alignment: "nil")
        imageView = bgImageView
        
        activityIndicator = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.medium)
        activityIndicator?.hidesWhenStopped = true
        activityIndicator?.startAnimating()
        activityIndicator?.center = self.center
        self.addSubview(activityIndicator!)
//        activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
//        let activityCenterYContraints = NSLayoutConstraint(item: activityIndicator!, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: formView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
//        let activityCenterXContraints = NSLayoutConstraint(item: activityIndicator!, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: formView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
//        activityCenterXContraints.isActive = true
//        activityCenterYContraints.isActive = true
        downloadImageWithUrl(urlString: Image, imageView: imageView)
        
//        closeBtn.addTarget(self, action: #selector(btnCloseTapped), for: .touchDragInside)

        
//        let frameWorkBundle = Bundle(for: type(of: self))
//        let imgClose = UIImage.init(named: "ic_close", in: frameWorkBundle, compatibleWith: nil);
//        closeBtn.setImage(imgClose, for: .normal)
//        closeBtn.isHidden = true;
        
        let btnClose = UIButton.init(type: .custom)
        btnClose.setTitleColor(UIColor.blue, for: .normal)
        let frameWorkBundle = Bundle(for: type(of: self))
        let imgClose = UIImage.init(named: "ic_close", in: frameWorkBundle, compatibleWith: nil);
        btnClose.setImage(imgClose, for: .normal)
        self.addSubview(btnClose)
        btnClose.translatesAutoresizingMaskIntoConstraints = false
        btnClose.addTarget(self, action: #selector(btnCloseTapped), for: .touchUpInside)
        btnClose.isHidden = true
        closeBtn = btnClose
        
        let metrics = ["padding": 0.0]
        let btnViews : [String : Any] = ["btnClose":btnClose]
        let btnHorizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "[btnClose(30)]-padding-|", options: [], metrics: metrics, views: btnViews)
        let btnVerticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-padding-[btnClose(30)]", options: [], metrics: metrics, views: btnViews)
        NSLayoutConstraint.activate(btnHorizontalConstraint)
        NSLayoutConstraint.activate(btnVerticalConstraint)
}
    @objc func btnCloseTapped(){
        P5SDKManager.updateFormResponse(mobileFormID: MobilePushId!, formResponse: "Banner", bannerView: "0", bannerClick: "0", bannerClose: "1", btnName: "",geofenceName: "",beaconName: "", screenName: screenName, widgetName: widgetName)
        self.removeFromSuperview()
        if self.delegate != nil{
            self.delegate?.bannerRemoved()
        }
    }
    @objc func downloadImageWithUrl(urlString : String, imageView:UIImageView){
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
            let image = P5SDKManager.sharedInstance.cache.object(forKey: urlString as AnyObject) as? UIImage
            imageView.image = image
            P5SDKManager.updateFormResponse(mobileFormID: MobilePushId!, formResponse: "Banner", bannerView: "1", bannerClick: "0", bannerClose: "0", btnName: "",geofenceName: "",beaconName: "", screenName: screenName, widgetName: widgetName)
            activityIndicator?.stopAnimating()
            activityIndicator?.removeFromSuperview()
            closeBtn.isHidden = false
            if self.delegate != nil{
                self.delegate?.bannerLoaded()
            }
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
                        imageView.image = img
                        P5SDKManager.sharedInstance.cache.setObject(img, forKey: urlString as AnyObject)
                        P5SDKManager.updateFormResponse(mobileFormID: self.MobilePushId!, formResponse: "Banner", bannerView: "1", bannerClick: "0", bannerClose: "0", btnName: "",geofenceName: "",beaconName: "", screenName: self.screenName, widgetName: self.widgetName)
                        self.activityIndicator?.stopAnimating()
                        self.activityIndicator?.removeFromSuperview()
                        self.closeBtn.isHidden = false;
                        if self.delegate != nil{
                            self.delegate?.bannerLoaded()
                        }
                    })
                }
            })
            task.resume()
        }
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let Redirect = formContent["Redirect"] as! String
        let Parameter = formContent["Parameter"] as! String
        // Your action
        P5SDKManager.updateFormResponse(mobileFormID: MobilePushId!, formResponse: "Banner", bannerView: "0", bannerClick: "1", bannerClose: "0", btnName: "",geofenceName: "",beaconName: "", screenName: screenName, widgetName: widgetName)
        if Redirect.count > 0{
            P5SDKManager.handleAction(actionType: .RedirectToScreen, redirectUrl: Redirect, parameters: Parameter,message: "", dataModel: [:],eventType: "")
        }
    }
}
