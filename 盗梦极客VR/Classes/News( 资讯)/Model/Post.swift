//
//	Post.swift
//
//	Create by wl on 11/5/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyJSON

class Post : NSObject, NSCoding{
    
    var avatarTemplate : String!
    var cooked : String!
    var createdAt : String!
    var id : Int!
    var name : String!
    var postNumber : Int!
    var username : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    required init(fromJson json: JSON!){
        if json == nil{
            return
        }
        avatarTemplate = json["avatar_template"].stringValue
        cooked = json["cooked"].stringValue
        createdAt = json["created_at"].stringValue
        id = json["id"].intValue
        name = json["name"].stringValue
        postNumber = json["post_number"].intValue
        username = json["username"].stringValue
    }
    
    /**
     * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> NSDictionary
    {
        let dictionary = NSMutableDictionary()
        if avatarTemplate != nil{
            dictionary["avatar_template"] = avatarTemplate
        }
        if cooked != nil{
            dictionary["cooked"] = cooked
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if id != nil{
            dictionary["id"] = id
        }
        if name != nil{
            dictionary["name"] = name
        }
        if postNumber != nil{
            dictionary["post_number"] = postNumber
        }
        if username != nil{
            dictionary["username"] = username
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        avatarTemplate = aDecoder.decodeObjectForKey("avatar_template") as? String
        cooked = aDecoder.decodeObjectForKey("cooked") as? String
        createdAt = aDecoder.decodeObjectForKey("created_at") as? String
        id = aDecoder.decodeObjectForKey("id") as? Int
        name = aDecoder.decodeObjectForKey("name") as? String
        postNumber = aDecoder.decodeObjectForKey("post_number") as? Int
        username = aDecoder.decodeObjectForKey("username") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encodeWithCoder(aCoder: NSCoder)
    {
        if avatarTemplate != nil{
            aCoder.encodeObject(avatarTemplate, forKey: "avatar_template")
        }
        if cooked != nil{
            aCoder.encodeObject(cooked, forKey: "cooked")
        }
        if createdAt != nil{
            aCoder.encodeObject(createdAt, forKey: "created_at")
        }
        if id != nil{
            aCoder.encodeObject(id, forKey: "id")
        }
        if name != nil{
            aCoder.encodeObject(name, forKey: "name")
        }
        if postNumber != nil{
            aCoder.encodeObject(postNumber, forKey: "post_number")
        }
        if username != nil{
            aCoder.encodeObject(username, forKey: "username")
        }
        
    }
    
}