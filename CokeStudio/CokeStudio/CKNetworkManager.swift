//
//  CKNetworkManager.swift
//  CokeStudio
//
//  Created by Abhishek Thapliyal on 3/18/17.
//  Copyright © 2017 Abhishek Thapliyal. All rights reserved.
//

import UIKit

class CKNetworkManager: NSObject {

    /**********************************************************************************
     NETWORK SERVICE CLASS : DEFINE WHATEVER NETWORK HTTP POST/GET REQUEST CALLS HERE
     ***********************************************************************************/
    
    public var responseArray : NSMutableArray?
    public var songsList : NSArray?
    
    
    //====================================================================================================================================
    // GET PLAYERS METHOD
    //====================================================================================================================================
    
    public func getSongs(completion : @escaping (_ articleArray:NSArray?, _ error:NSError?) -> Void) {
        
        let URLString : String = "http://starlord.hackerearth.com/edfora/cokestudio"
        let request : NSMutableURLRequest = CKHTTPRequest.getServerRequest(urlString: URLString, paramString: nil)
        CKHTTPResponse.responseWithRequest(request: request, requestTitle: "FETCH_SONGS", completion: { (json, error) in
            
            print("ERROR(IF-ANY) :: \(error?.localizedDescription)")
            self.responseArray = NSMutableArray()
            if (error == nil)
            {
                let responseList : [Any] = json as! [Any]
                self.songsList = NSArray(array: responseList as NSArray)
                for songDict in self.songsList as! [[String:Any]] {
                    
                    let songObj = CKSong(dictionary: songDict)
                    self.responseArray?.add(songObj)
                    print("SONG_NAME \(songObj.song)")
                }
            }
            completion(self.responseArray!, error)
        })
    }
}

