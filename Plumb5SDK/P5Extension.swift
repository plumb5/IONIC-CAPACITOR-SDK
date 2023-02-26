//
//  Extension.swift
//  Plumb5SDK
//
//  Created by Shama on 5/12/17.
//  Copyright © 2017 Plumb5. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

private let swizzling: (UIViewController.Type) -> () = { viewController in
    
    let originalSelector = #selector(viewController.viewWillAppear)
    let swizzledSelector = #selector(viewController.proj_viewWillAppear)
    
    let originalMethod = class_getInstanceMethod(viewController, originalSelector)
    let swizzledMethod = class_getInstanceMethod(viewController, swizzledSelector)
    
    method_exchangeImplementations(originalMethod!, swizzledMethod!)
    
    let originalSelectorViewDidLoad = #selector(viewController.viewDidLoad)
    let swizzledSelectorViewDidLoad = #selector(viewController.proj_viewDidLoad)
    
    let originalMethodViewDidLoad = class_getInstanceMethod(viewController, originalSelectorViewDidLoad)
    let swizzledMethodViewDidLoad = class_getInstanceMethod(viewController, swizzledSelectorViewDidLoad)
    
    method_exchangeImplementations(originalMethodViewDidLoad!, swizzledMethodViewDidLoad!)
}

extension UIViewController : MFMessageComposeViewControllerDelegate {
    
    //    open override class func initialize() {
    //
    //    }
    
    public static func swizzleViewWillAppear() {
        guard self === UIViewController.self else { return }
        swizzling(self)
    }
    
    // MARK: - Method Swizzling
    
    @objc func proj_viewWillAppear()  {
        print("proj_viewWillAppear")
        if P5SDKManager.sharedInstance.p5BundleIdentifier == nil {
            P5SDKManager.sharedInstance.validatAppKey(completion: { (success) in
                if success {
                    self.trackScreenFlow()
                }else{
                    print("Appkey doesn't not exist")
                }
            })
        }else{
            trackScreenFlow()
        }
        
    }
    @objc func proj_viewDidLoad()  {
        //        if P5SDKManager.sharedInstance.p5BundleIdentifier == nil {
        //            P5SDKManager.sharedInstance.validatAppKey(completion: { (success) in
        //                if success {
        //                    self.trackScreenFlow()
        //                }else{
        //                  print("Appkey doesn't not exist")
        //                }
        //            })
        //        }else{
        //           trackScreenFlow()
        //        }
        print("proj_viewDidLoad")
        let vv : UIViewController = self;
        let mirrored_object = Mirror(reflecting: vv)
        var extraParam  = Dictionary<String,Any>()
        for (index, attr) in mirrored_object.children.enumerated() {
            if attr.value is String, let property_name = attr.label as String? {
                extraParam[property_name] = attr.value
                print("Attr \(index): \(property_name) = \(attr.value)")
            }
        }
        let viewControllerName = NSStringFromClass(type(of: self))
        if viewControllerName == "UIInputWindowController" || viewControllerName == "UIApplicationRotationFollowingController"  || viewControllerName == "UICompatibilityInputViewController" || viewControllerName == "UIActivityViewController" || viewControllerName.hasPrefix("UI") || viewControllerName.hasPrefix("_UI") {
            return
        }
        P5SDKManager.showInAppBannerDialog(screenName: viewControllerName);
    }
    
    @objc func trackScreenFlow(){
        let viewControllerName = NSStringFromClass(type(of: self))
        if viewControllerName == "UIInputWindowController" || viewControllerName == "UIApplicationRotationFollowingController" || viewControllerName == "UICompatibilityInputViewController" || viewControllerName == "UIActivityViewController" || viewControllerName.hasPrefix("UI") || viewControllerName.hasPrefix("_UI") {
            return
        }
        let vv : UIViewController = self;
        let mirrored_object = Mirror(reflecting: vv)
        var extraParam  = Dictionary<String,Any>()
        
        for (index, attr) in mirrored_object.children.enumerated() {
            if attr.value is String, let property_name = attr.label as String? {
                extraParam[property_name] = attr.value
                print("Attr \(index): \(property_name) = \(attr.value)")
            }
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject:extraParam, options:[])
            let dataString = String(data: data, encoding: String.Encoding.utf8)!
            print(dataString)
            P5SDKManager.initSession(screenName: viewControllerName, paramDict: dataString)
            // do other stuff on success
            
        } catch {
            print("JSON serialization failed:  \(error)")
        }
        
        print("proj_viewWillAppear: \(viewControllerName)")
        P5SDKManager.registerDevice()
        P5SDKManager.sharedInstance.currentVC = self;
    }
    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc public func showToast(message : String) {
        if message.count == 0 {
            return
        }
        let toastLabel = UILabel(frame: CGRect(x: 30, y: self.view.frame.size.height-60, width: self.view.frame.size.width - 60, height: 40))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
        self.view.addSubview(toastLabel)
    }
}
