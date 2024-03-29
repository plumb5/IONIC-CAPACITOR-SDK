//
//  P5Contants.swift
//  Plumb5SDK
//
//  Created by Shama on 5/8/17.
//  Copyright © 2017 Plumb5. All rights reserved.
//

import Foundation

struct Constants {
    static let version = "2.0"
    static let base_url = Bundle.main.object(forInfoDictionaryKey: "serviceURL") as? String ?? ""

    static let key_manufacturer = "Manufacturer"
    static let key_name = "DeviceName"
    static let key_os = "IOs"
    static let key_id = "Id"
    static let key_osversion = "OsVersion"
    static let key_carriername = "CarrierName"
    static let key_resolution = "Resolution"
    static let key_appversion = "AppVersion"
    static let key_appkey = "AppKey"
    static let key_GcmRegId = "GcmRegId"
    static let key_deviceinfo = "DeviceInfo"
    static let key_DeviceId = "DeviceId"
    static let key_EmailId = "EmailId"
    static let key_PhoneNumber = "PhoneNumber"
    static let key_ExtraParam = "ExtraParam"
    static let key_TrackData = "TrackData"
    static let key_SessionId = "SessionId"
    static let key_ScreenName = "ScreenName"
    static let key_CampaignId = "CampaignId"
    static let key_NewSession = "NewSession"
    static let key_Offline = "Offline"
    static let key_TrackDate = "TrackDate"
    static let key_GeofenceId = "GeofenceId"
    static let key_Locality = "Locality"
    static let key_City = "City"
    static let key_State = "State"
    static let key_Country = "Country"
    static let key_CountryCode = "CountryCode"
    static let key_Latitude = "Latitude"
    static let key_Longitude = "Longitude"
    static let key_PageParameter = "PageParameter"
    static let key_FieldType = "FieldType"
    static let key_EventId = "EventId"
    static let key_EventValue = "EventValue"
    static let key_AppKey = "AppKey"
    static let key_PackageName = "PackageName"
    static let key_EventTrack_Type = "Type"
    static let key_EventTrack_Name = "Name"
    static let key_EventTrack_Value = "Value"
    static let key_EventData = "EventData"

    static let api_RegisterDevice = "DeviceRegistration"
    static let api_RegisterUser = "ContactDetails"
    static let api_initSession = "Tracking"
    static let api_logData = "logData"
    static let api_TransData = "TransData"
    static let api_endSession = "endSession"
    static let api_formResponses = "PushResponses"
    static let api_GetField = "InApppDisplaySettingsDetails"
    static let api_GetPushRequest = "GetPushRequest"
    static let api_GetBeaconRequest = "GetBeaconRequest"
    static let api_GetPushCampaign = "GetPushCampaign"
    static let api_ValidatAppKey = "GetGcmProjectNoPackageName"
    static let api_ValidatAppKeyNew = "PackageInfo"
    static let api_LogDataKey = "logData"
    static let api_EventResponses = "EventResponses"

    static let value_ios = "iOS"
    static let value_apple = "Apple"
    static let value_wifi = "WiFi"
    static let value_offlineMode = "1"
    static let value_onlineMode = "0"

    static let key_mobileCountryCode = "mobileCountryCode"
    static let key_mobileNetworkCode = "mobileNetworkCode"
    static let key_isoCountryCode = "isoCountryCode"

    static let key_GeoLocations = "GeoLocations"

    static let key_pushidentifier = "P5pushAction"

    // Inapp banner keys
    static let key_Position = "Position"
    static let key_Height = "Height"
    static let key_Action = "Action"
    static let key_Align = "Align"
    static let key_BgColor = "BgColor"
    static let key_Border = "Border"
    static let key_BorderRadius = "BorderRadius"
    static let key_BorderWidth = "BorderWidth"
    static let key_Category = "Category"
    static let key_CloseDialog = "CloseDialog"
    static let key_Color = "Color"
    static let key_Group = "Group"
    static let key_ImageUrl = "ImageUrl"
    static let key_Mandatory = "Mandatory"
    static let key_Margin = "Margin"
    static let key_Message = "Message"
    static let key_Name = "Name"
    static let key_Orientation = "Orientation"
    static let key_Padding = "Padding"

    static let key_Parameter = "Parameter"
    static let key_Redirect = "Redirect"
    static let key_Score = "Score"

    static let key_Size = "Size"
    static let key_Style = "Style"
    static let key_text = "Text"
    static let key_Type = "Type"
    static let key_Width = "Width"
    static let key_Animation = "Animation"

    static let key_BeaconId = "BeaconId"
    static let key_PushId = "PushId"
    static let key_BeaconUuid = "BeaconUuid"
    static let key_MajorId = "MajorId"
    static let key_MinorId = "MinorId"
    static let key_Radius = "Radius"
    static let key_EntryExist = "EntryExist"
    static let key_BeaconName = "BeaconName"
    static let key_SavedBeaconData = "beaconData"
    static let key_SavedBeaconNames = "beaconNames"

    static let key_NotificationType = "keyNotifocation"
    static let key_NotificationType_Banner = "banner_notifocation"
    static let key_NotificationType_GeoFence = "geofence_notifocation"
    static let key_NotificationType_Beacon = "beacon_notifocation"
    static let key_NotificationData = "notifocationData"
    static let key_OnEntry = "onEntry"
    static let key_Entry = "Entry"
    static let key_EntryLat = "EntryLat"
    static let key_EntryLng = "EntryLng"
    static let key_MobilePushId = "campaignid"
    static let key_PushType = "PushType"
    static let key_Ticker = "Ticker"
    static let key_Title = "Title"
    static let key_SubText = "SubText"
    static let key_RedirectTo = "RedirectTo"
    static let key_Parameters = "Parameters"
    static let key_DeepLinkUrl = "DeepLinkUrl"
    static let key_ExternalUrl = "ExternalUrl"
    static let key_ExtraButtons = "ExtraButtons"
    static let key_MediaType = "media-type"
    static let key_Beacon = "Beacon"
    static let key_MobileFormId = "MobileFormId"
    static let key_WorkFlowDataId = "WorkFlowDataId"
    static let key_FormResponses = "FormResponses"
    static let key_BannerView = "BannerView"
    static let key_BannerClick = "BannerClick"
    static let key_BannerClose = "BannerClose"
    static let key_ButtonName = "ButtonName"
    static let key_GeofenceName = "GeofenceName"
}

extension Date {
    static func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        return dateFormatter.string(from: Date())
    }
}

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
