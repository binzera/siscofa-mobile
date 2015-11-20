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
        
        if NSJSONSerialization.isValidJSONObject(value) {
            do {
                
                if let data : NSData = try NSJSONSerialization.dataWithJSONObject(value, options: .PrettyPrinted) {
                    if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                        return string as String
                    }
                }
                
            } catch {
                print("JSONHelper: Erro ao converter o Objeto para JSON")
            }
            
        }
        return ""
    }
    
    
    func JSONParseArray(jsonString: String) -> [AnyObject] {
        if let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                if let array =  try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments )  as? [AnyObject] {
                    return array
                }
            } catch {
                print("Erro na conversao do JSON na Classe JsonHelper")
            }
        }
        return [AnyObject]()
    }
    
    func JSONParseDictionary(jsonString: String) -> [String: AnyObject] {
        if let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                if let dictionary =  try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments )  as? [String: AnyObject] {
                    return dictionary
                }
            } catch {
                print("Erro na conversao do JSON na Classe JsonHelper")
            }
            
        }
        return [String: AnyObject]()
    }
    
}
