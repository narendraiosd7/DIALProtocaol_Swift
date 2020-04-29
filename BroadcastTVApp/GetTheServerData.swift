//
//  GetTheServerData.swift
//  BroadcastTVApp
//
//  Created by Vadde Narendra on 4/15/20.
//  Copyright © 2020 Narendra Vadde. All rights reserved.
//

import UIKit
import Foundation

class GetServerData {
    var URLReqObj:URLRequest!
    var dataTaskObj:URLSessionDataTask!
    
    
   func getRequest(urlString : String, completionHandler : @escaping (_ result : Details?, _ errrorString : String ) -> ()){
            
            do {
                guard let url = URL(string: urlString) else {
                    completionHandler(nil,"")
                    return
                }
                let request = NSMutableURLRequest(url: url,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "GET"
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                
                guard let data = data else{
                    completionHandler(nil, "")
                    return
                }
                
                if (error != nil) {
                    print(error ?? "")
                    completionHandler(nil, "")
                    
                } else {
                    
                    do {
                        
                        let userData = try JSONDecoder().decode(Details.self, from: data)
                        completionHandler(userData, "no error")
                    } catch let parseError {
                        print(parseError)
                    }
                    
                }
            })
            
            dataTask.resume()
            }
            catch let parseError {
                print(parseError)
            }
        }
}

