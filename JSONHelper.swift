//
//  JSONHelper.swift
//  SiscofaMobile
//
//  Created by Glaubert Moreira Schult on 11/06/15.
//  Copyright (c) 2015 GMS. All rights reserved.
//

import Foundation

class JSONHelper {
    
    class func JSONStringify(value: AnyObject, prettyPrinted: Bool = false) -> String {
        var options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : nil
        if NSJSONSerialization.isValidJSONObject(value) {
            if let data = NSJSONSerialization.dataWithJSONObject(value, options: options, error: nil) {
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    return string
                }
            }
        }
        return ""
    }
    
    
    func JSONParseArray(jsonString: String) -> [AnyObject] {
        if let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding) {
            if let array = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: nil)  as? [AnyObject] {
                return array
            }
        }
        return [AnyObject]()
    }
    
    func JSONParseDictionary(jsonString: String) -> [String: AnyObject] {
        if let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding) {
            if let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: nil)  as? [String: AnyObject] {
                return dictionary
            }
        }
        return [String: AnyObject]()
    }
    
}
