//
//  UserModel.swift
//  盗梦极客VR
//
//  Created by wl on 5/6/16.
//  Copyright © 2016 wl. All rights reserved.
//

//
//	User.swift
//
//	Create by wl on 6/5/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyJSON

class User : NSObject, NSCoding{
    
    var avatar : String!
    var email : String!
    var id : Int!
    var nickname : String!
    var registered : String!
    var username : String!
    var displayname: String!
    var userCreated: Bool!
    var cookie: String!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    required init(fromJson json: JSON!){
        if json == nil{
            return
        }
        avatar = json["avatar"].stringValue
        email = json["email"].stringValue
        id = json["id"].intValue
        nickname = json["nickname"].stringValue
        registered = json["registered"].stringValue
        username = json["username"].stringValue
        displayname = json["display_name"].stringValue
        userCreated = json["bbs_user_created"].boolValue
        cookie = json["cookie"].stringValue
    }
    
    /**
     * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> NSDictionary
    {
        let dictionary = NSMutableDictionary()
        if avatar != nil{
            dictionary["avatar"] = avatar
        }
        if email != nil{
            dictionary["email"] = email
        }
        if id != nil{
            dictionary["id"] = id
        }
        if nickname != nil{
            dictionary["nicename"] = nickname
        }
        if registered != nil{
            dictionary["registered"] = registered
        }
        if username != nil{
            dictionary["username"] = username
        }
        if displayname != nil{
            dictionary["display_name"] = displayname
        }
        if userCreated != nil{
            dictionary["bbs_user_created"] = userCreated
        }
        if cookie != nil{
            dictionary["cookie"] = cookie
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        avatar = aDecoder.decodeObjectForKey("avatar") as? String
        email = aDecoder.decodeObjectForKey("email") as? String
       
        id = aDecoder.decodeObjectForKey("id") as? Int
        nickname = aDecoder.decodeObjectForKey("nicename") as? String
        registered = aDecoder.decodeObjectForKey("registered") as? String
        username = aDecoder.decodeObjectForKey("username") as? String
        displayname = aDecoder.decodeObjectForKey("display_name") as? String
        userCreated = aDecoder.decodeObjectForKey("bbs_user_created") as? Bool
        cookie = aDecoder.decodeObjectForKey("cookie") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encodeWithCoder(aCoder: NSCoder)
    {
        if avatar != nil{
            aCoder.encodeObject(avatar, forKey: "avatar")
        }
        if email != nil{
            aCoder.encodeObject(email, forKey: "email")
        }
        if id != nil{
            aCoder.encodeObject(id, forKey: "id")
        }
        if nickname != nil{
            aCoder.encodeObject(nickname, forKey: "nicename")
        }
        if registered != nil{
            aCoder.encodeObject(registered, forKey: "registered")
        }
        if username != nil{
            aCoder.encodeObject(username, forKey: "username")
        }
        if displayname != nil{
            aCoder.encodeObject(displayname, forKey: "display_name")
        }
        if userCreated != nil{
            aCoder.encodeObject(userCreated, forKey: "bbs_user_created")
        }
        if cookie != nil{
            aCoder.encodeObject(cookie, forKey: "cookie")
        }
        
    }
    
}