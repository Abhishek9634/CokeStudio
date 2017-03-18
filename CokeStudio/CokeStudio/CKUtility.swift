//
//  CKUtility.swift
//  CokeStudio
//
//  Created by Abhishek Thapliyal on 3/18/17.
//  Copyright © 2017 Abhishek Thapliyal. All rights reserved.
//

import UIKit

class CKUtility: NSObject {

    /**************************************************************************
     LOADS DATA VIA LOCAL URL
     ***************************************************************************/
    
    class func localFilePathForUrl(previewUrl: String) -> URL? {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        if let url = NSURL(string: previewUrl), let lastPathComponent = url.lastPathComponent {
            let fullPath = documentsPath.appendingPathComponent(lastPathComponent)
            return URL(fileURLWithPath:fullPath)
        }
        return nil
    }
}
