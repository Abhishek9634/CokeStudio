//
//  CKSong.swift
//  CokeStudio
//
//  Created by Abhishek Thapliyal on 3/18/17.
//  Copyright © 2017 Abhishek Thapliyal. All rights reserved.
//

import UIKit

class CKSong: NSObject {

    public var song : NSString?
    public var url : NSString?
    public var artists : NSString?
    public var cover_image : NSString?
    public var favourite : Bool?
    public var localURL : NSString?
    
    override init() {
        
    }
    
    /********************************************************
     CUSTOM INTIALIZATION : INIT WITH DICTIONARY
     ********************************************************/
    
    init(dictionary : [String:Any]) {
        super.init()
        self.parseDictionary(dictionary: dictionary)
    }
    
    /********************************************************
     PARSING DICTIONARY : MAPPING DATA TO CLASS PROPERTIES
     ********************************************************/
    
    public func parseDictionary(dictionary : [String:Any]) {
        
        self.song = dictionary["song"] as? NSString
        self.url = dictionary["url"] as? NSString
        self.artists = dictionary["artists"] as? NSString
        self.cover_image = dictionary["cover_image"] as? NSString
        self.favourite = false
        localURL = nil
    }
}
