//
//  AlamofireSwiftyJSON.swift
//  JKPinTu-Swift
//
//  Created by bingjie-macbookpro on 15/12/22.
//  Copyright © 2015年 Bingjie. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension Request {
    
    /**
     Adds a handler to be called once the request has finished.
     
     - parameter completionHandler: A closure to be executed once the request has finished. The closure takes 4 arguments: the URL request, the URL response, if one was received, the SwiftyJSON enum, if one could be created from the URL response and data, and any error produced while creating the SwiftyJSON enum.
     
     - returns: The request.
     */
    public func jk_responseSwiftyJSON(queue: dispatch_queue_t? = nil, completionHandler: (NSURLRequest, NSHTTPURLResponse?, SwiftyJSON.JSON, ErrorType?) -> Void) -> Self {
        
        return responseJSON(completionHandler: { (response) -> Void in
            var responseJSON: JSON
            if response.result.isFailure{
                responseJSON = JSON.null
            }else{
                responseJSON = SwiftyJSON.JSON(response.result.value!)
            }
            dispatch_async(queue ?? dispatch_get_main_queue(), {
                completionHandler(self.request!, self.response, responseJSON, response.result.error)
            })
        })
    }
    
    
}