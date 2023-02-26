//
//  P5ServiceManager.swift
//  Plumb5SDK
//
//  Created by Shama on 5/1/17.
//  Copyright © 2017 Plumb5. All rights reserved.
//

import Foundation
import Alamofire


class P5ServiceManager {
    static let sharedInstance = P5ServiceManager()
    
    // Declare an initializer
    // Because this class is singleton only one instance of this class can be created
    private init() {
        print("P5ServiceManager has been initialized")
    }
    
    var p5getAppKey="",p5getScreenname="",p5getUserInfo="";
    
    var _p5getAppKey: String {
        set { p5getAppKey = _p5getAppKey }
        get {
            if p5getAppKey.isEmpty {
                //
            }
            return p5getAppKey
        }
    }
    
    func sendPostRequestWithURL(url: String, paramDict:Dictionary<String, Any>? = nil,completion: @escaping (_ result:Any?,_ success:Bool) -> ()) {
     #if DEBUG
                print("postParamDict post = %@ url = %@  data = %@",((paramDict?.description)! ),url,Date())
            #endif
//        print("sendPostRequestWithURL %@ url = %@", Date() , url)
        let request : DataRequest = Alamofire.request(url,method: .post, parameters: paramDict, encoding: JSONEncoding.default, headers: [:]).responseJSON { (response:DataResponse<Any>) in
//                print("sendPostRequestWithURL got response %@ url = %@", Date() , url)
                switch(response.result) {
                case .success(_):
                    if let json = response.result.value {
                        print("Succes: \(json)") // serialized json response
                              completion(json, true)
                    }
              
                    break
                    
                case .failure(_):
                    print("Failure : \(String(describing: response.result.error))")
                    completion(nil,false)

                    break
                    
                }
            }
        request.session.configuration.timeoutIntervalForRequest = 300
        request.session.configuration.timeoutIntervalForResource = 300
//        print("time out interval = \(request.request?.timeoutInterval)")
    }
    
    func sendGetRequestWithURL(url: String, paramDict:Dictionary<String, String>? = nil,completion: @escaping (_ result:Any?,_ success:Bool) -> ()) {
    #if DEBUG
            print("postParamDict get = %@ url = %@  data = %@",((paramDict?.description)! ),url,Date())
        #endif

//        print("sendGetRequestWithURL %@ url = %@", Date() , url)
        let request : DataRequest = Alamofire.request(url,method: .get, parameters: paramDict, encoding: URLEncoding.queryString, headers: [:]).responseJSON { (response:DataResponse<Any>) in
//            print("sendGetRequestWithURL got response %@ url = %@", Date() , url)
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response : \(response.result.value)")
                    if let data = response.data {
//                        let jsonObj = JSON(data: response.data!)
//                        let FormContent = json["FormContent"] as Dictionary
                        do{
                            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves)
                            print(json)
                            completion(json, true)
                        }catch{
                            print("Unable to parse json response");
                            completion(nil, false)
                        }
                    }else{
                        completion(nil, false)
                    }
                }
//                guard let value = response.result.value as? [String: Any]
//                    else {
//                        print("Malformed data received from \(url)")
//                        completion(nil,false)
//                        return
//                }
//                completion(response.result.value, true)
                break
                
            case .failure(_):
                print("Failure : \(String(describing: response.result.error))")
                completion(nil,false)
                
                break
                
            }
        }
        request.session.configuration.timeoutIntervalForRequest = 300
        request.session.configuration.timeoutIntervalForResource = 300
    }

    
}
