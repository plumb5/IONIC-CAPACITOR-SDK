//
//  P5SDKManager.swift
//  Plumb5SDK
//
//  Created by Shama on 5/1/17.
//  Copyright © 2017 Plumb5. All rights reserved.
//

import Capacitor
import CoreLocation
import Foundation
import MessageUI
import UIKit

import UserNotifications

public enum Actions: String {
    case Form
    case Dismiss = "Cancel"
    case RedirectToScreen = "Screen"
    case DeepLinkingURL = "Deeplink"
    case ExternalURL = "Browser"
    case Copy
    case Call
    case Share
    case RemindLater = "Reminder"
    case EventTracking = "Event"
    case TextMessage = "Sms"
    case Permission
    case None = "0"
}

public protocol P5ActionsDelegate {
    func handleActionWithType(type: Actions, userInfo: [String: Any])
}

public class P5SDKManager: P5LocationDelegate {
    func updateLocation() {
        
    }
    
    func updateLocationForGeoFence() {
        
    }
    
    public weak var P5plugin: CAPPlugin?
    public static let BUTTON_CLICK = "BUTTON_CLICK"
    public static let sharedInstance = P5SDKManager()
    public var isPushingOfflineDataIsInProgress: Bool = false
    public var currentVC: UIViewController?
    public var delegate: P5ActionsDelegate?

    var geofenceRegionDate: [String: Any]?
    var beaconRegionDate: [String: Any]?
    var deviceTokenUpdated = false

    // Declare an initializer
    // Because this class is singleton only one instance of this class can be created
    private init() {
        print("P5SDKManager has been initialized")
    }

    public var p5DeviceToken = "" {
        didSet {
            deviceTokenUpdated = true
   
            deviceTokenUpdated = false
        }
    }

    var p5getAppKey = ""
    var p5getUrl = ""
    var p5Version = ""
    var screenName = ""
    var cache: NSCache<AnyObject, AnyObject>!
//    var p5ProjectNumber : String?
    var p5BundleIdentifier: String?
    var inappQueue: String = ""
    var bannerQueue: String = ""
    var bannerView: UIView?
    var bannerDelegate: P5BannerDelegate?

    public func checkNetworkRecheablity() -> Bool {
        let reachability = Reachability()!

        if reachability.connection != .none {
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
                return true
            } else {
                print("Reachable via Cellular")
                return true
            }
        } else {
            print("Network not reachable")
            return false
        }
    }

    func saveDeviceInfoStatusInDB() {
        UserDefaults.standard.setValue(P5DeviceInfo.sharedInstance.getOSVersion(), forKey: Constants.key_osversion)
        UserDefaults.standard.setValue(P5DeviceInfo.sharedInstance.getCarrier(), forKey: Constants.key_carriername)
        UserDefaults.standard.setValue(p5Version, forKey: Constants.key_appversion)
        UserDefaults.standard.setValue(P5DeviceInfo.sharedInstance.getResolution(), forKey: Constants.key_resolution)
    }

 




    public class func getDeviceInfoAsJson() -> [String: String] {
        print(P5DeviceInfo.sharedInstance.getDeviceInfoAsJson())

        return P5DeviceInfo.sharedInstance.getDeviceInfoAsJson()
    }





    func processGetFieldData(array: NSDictionary, screenName: String) {
        createDialog(object: array, screenName: screenName)
    }

    func processGetFieldData_Banner(array: NSDictionary, imageView: P5BannerView /* , closeBtn: UIButton */ ) {
        let obj = array[0] as! NSDictionary
        let Status = obj.value(forKey: "Status") as! Bool
        if Status {
            createBanner(object: obj, banner: imageView /* , closeBtn: closeBtn */ )
        }
    }

    func createDialog(object: NSDictionary, screenName: String) {
        let keyWindow = UIWindow.key
        let banner = InAppBanner()
        banner.screenName = screenName
//        banner.frame = (keyWindow?.frame)!
        keyWindow?.addSubview(banner)
        keyWindow?.bringSubviewToFront(banner)
//        keyWindow?.rootViewController?.view.addSubview(banner)
//        keyWindow?.rootViewController?.view.bringSubview(toFront: banner)
        banner.translatesAutoresizingMaskIntoConstraints = false
        let views: [String: Any] = ["formView": banner]
        let horizontalVisualString = "|[formView]|"
        let verticalVisualString = "V:|[formView]|"
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: horizontalVisualString, options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(horizontalConstraints)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: verticalVisualString, options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(verticalConstraints)
        banner.dataModel = object
    }

    func createBanner(object: NSDictionary, banner: P5BannerView /* , closeBtn: UIButton */ ) {
//        let banner : P5BannerView = P5BannerView()
//        banner.closeBtn = closeBtn
        banner.dataModel = object
    }

    func showPushCampaign(userInfo: [String: Any], beaconName: String, geofenceName: String) {
        let keyWindow = UIApplication.shared.windows[0]
        let banner = P5NotificationDetailView()
        banner.frame = keyWindow.frame
        keyWindow.addSubview(banner)
        banner.geofenceName = geofenceName
        banner.beaconName = beaconName
        banner.userInfo = userInfo
    }

    public class func handleActions(params: [String: String], dataModel: [String: Any], eventType: String) {
        let action = params[Constants.key_Action]
        if action?.count == 0 {
            return
        }
        let actionType = Actions(rawValue: action!)!
        let redirectUrl: String = params[Constants.key_Redirect]!
        let parameters: String = params[Constants.key_Parameter]!
        let message: String = params[Constants.key_Message]!

        P5SDKManager.handleAction(actionType: actionType, redirectUrl: redirectUrl, parameters: parameters, message: message, dataModel: dataModel, eventType: eventType)
    }

    public class func handleAction(actionType: Actions, redirectUrl: String, parameters: String, message _: String, dataModel: [String: Any], eventType: String) {
        switch actionType {
        case .Form:
            P5SDKManager.sharedInstance.delegate?.handleActionWithType(type: actionType, userInfo: [Constants.key_Redirect: redirectUrl, Constants.key_Parameter: parameters])

            let json = "{" + "\"routeUrl\":" + "\"" + redirectUrl + "\"" + "}"

            P5SDKManager.sharedInstance.P5plugin?.bridge?.triggerWindowJSEvent(eventName: "onPushNotification", data: json)
        case .Dismiss:
            break
        case .RedirectToScreen:
//            P5SDKManager.sharedInstance.delegate?.handleActionWithType(type: actionType, userInfo: [Constants.key_Redirect : redirectUrl, Constants.key_Parameter:parameters]);
            let json = "{" + "\"routeUrl\":" + "\"" + redirectUrl + "\"" + "}"

            P5SDKManager.sharedInstance.P5plugin?.bridge?.triggerWindowJSEvent(eventName: "onPushNotification", data: json)
        case .ExternalURL:
            guard let url = URL(string: redirectUrl)
            else {
                return
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        case .DeepLinkingURL:
            P5SDKManager.sharedInstance.delegate?.handleActionWithType(type: actionType, userInfo: [Constants.key_Redirect: redirectUrl, Constants.key_Parameter: parameters])
        case .Copy:
            let pasteboard = UIPasteboard.general
            pasteboard.string = redirectUrl
//            P5SDKManager.sharedInstance.currentVC?.showToast(message: message)
        case .Call:
            guard let url = URL(string: "telprompt://" + redirectUrl)
            else {
                return
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        case .Share:
            P5SDKManager.sharedInstance.share(text: redirectUrl)
        case .RemindLater:
            let center = UNUserNotificationCenter.current()
            let reminder = UNMutableNotificationContent()
//            let fireDate = Date().addingTimeInterval((redirectUrl as NSString).doubleValue * 60.0)
            let fireDate = (redirectUrl as NSString).doubleValue * 60.0

            reminder.userInfo = [Constants.key_NotificationType: Constants.key_NotificationType_Banner, Constants.key_NotificationData: dataModel]
            reminder.body = parameters

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: fireDate, repeats: false)

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: reminder, trigger: trigger)
            center.add(request)
        //  UIApplication.shared.scheduleLocalNotification(reminder);
        case .EventTracking:
                break
        case .TextMessage:
            P5SDKManager.sharedInstance.initiateSMS(number: redirectUrl, msg: parameters)
        case .Permission:
            P5SDKManager.sharedInstance.delegate?.handleActionWithType(type: actionType, userInfo: [Constants.key_Redirect: redirectUrl, Constants.key_Parameter: parameters])
        case .None:
            break
        default:
            break
        }
    }

    func initiateSMS(number _: String, msg _: String) {
//        if (MFMessageComposeViewController.canSendText()) {
//            let controller = MFMessageComposeViewController()
//            controller.body = msg
//            controller.recipients = [number]
//            controller.messageComposeDelegate = P5SDKManager.sharedInstance.currentVC! as MFMessageComposeViewControllerDelegate
//            P5SDKManager.sharedInstance.currentVC?.present(controller, animated: true, completion: nil)
//        }
    }

    func share(text: String) {
        let textToShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = P5SDKManager.sharedInstance.currentVC?.view // so that iPads won't crash
        // present the view controller
        P5SDKManager.sharedInstance.currentVC?.present(activityViewController, animated: true, completion: nil)
    }

    

    public func hexStringToUIColor(hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    public static func show(message: String, controller: UIViewController) {
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 25
        toastContainer.clipsToBounds = true

        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font.withSize(12.0)
        toastLabel.text = message
        toastLabel.clipsToBounds = true
        toastLabel.numberOfLines = 0

        toastContainer.addSubview(toastLabel)
        controller.view.addSubview(toastContainer)

        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false

        let a1 = NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 15)
        let a2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -15)
        let a3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -15)
        let a4 = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 15)
        toastContainer.addConstraints([a1, a2, a3, a4])

        let c1 = NSLayoutConstraint(item: toastContainer, attribute: .width, relatedBy: .lessThanOrEqual, toItem: controller.view, attribute: .width, multiplier: 1, constant: -90)
        let c2 = NSLayoutConstraint(item: toastContainer, attribute: .centerX, relatedBy: .equal, toItem: controller.view, attribute: .centerX, multiplier: 1, constant: 1)
        controller.view.addConstraints([c1, c2])

        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: { _ in
                toastContainer.removeFromSuperview()
            })
        })
    }
}

// Helper function inserted by Swift 4.2 migrator.
private func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value) })
}
