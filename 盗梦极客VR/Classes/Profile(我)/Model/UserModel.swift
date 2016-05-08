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
    var descriptionField : String!
    var displayname : String!
    var email : String!
    var firstname : String!
    var id : Int!
    var lastname : String!
    var nicename : String!
    var nickname : String!
    var registered : String!
    var url : String!
    var username : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    required init(fromJson json: JSON!){
        if json == nil{
            return
        }
        avatar = json["avatar"].stringValue
        descriptionField = json["description"].stringValue
        displayname = json["displayname"].stringValue
        email = json["email"].stringValue
        firstname = json["firstname"].stringValue
        id = json["id"].intValue
        lastname = json["lastname"].stringValue
        nicename = json["nicename"].stringValue
        nickname = json["nickname"].stringValue
        registered = json["registered"].stringValue
        url = json["url"].stringValue
        username = json["username"].stringValue
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
        if descriptionField != nil{
            dictionary["description"] = descriptionField
        }
        if displayname != nil{
            dictionary["displayname"] = displayname
        }
        if email != nil{
            dictionary["email"] = email
        }
        if firstname != nil{
            dictionary["firstname"] = firstname
        }
        if id != nil{
            dictionary["id"] = id
        }
        if lastname != nil{
            dictionary["lastname"] = lastname
        }
        if nicename != nil{
            dictionary["nicename"] = nicename
        }
        if nickname != nil{
            dictionary["nickname"] = nickname
        }
        if registered != nil{
            dictionary["registered"] = registered
        }
        if url != nil{
            dictionary["url"] = url
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
        avatar = aDecoder.decodeObjectForKey("avatar") as? String
        descriptionField = aDecoder.decodeObjectForKey("description") as? String
        displayname = aDecoder.decodeObjectForKey("displayname") as? String
        email = aDecoder.decodeObjectForKey("email") as? String
        firstname = aDecoder.decodeObjectForKey("firstname") as? String
        id = aDecoder.decodeObjectForKey("id") as? Int
        lastname = aDecoder.decodeObjectForKey("lastname") as? String
        nicename = aDecoder.decodeObjectForKey("nicename") as? String
        nickname = aDecoder.decodeObjectForKey("nickname") as? String
        registered = aDecoder.decodeObjectForKey("registered") as? String
        url = aDecoder.decodeObjectForKey("url") as? String
        username = aDecoder.decodeObjectForKey("username") as? String
        
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
        if descriptionField != nil{
            aCoder.encodeObject(descriptionField, forKey: "description")
        }
        if displayname != nil{
            aCoder.encodeObject(displayname, forKey: "displayname")
        }
        if email != nil{
            aCoder.encodeObject(email, forKey: "email")
        }
        if firstname != nil{
            aCoder.encodeObject(firstname, forKey: "firstname")
        }
        if id != nil{
            aCoder.encodeObject(id, forKey: "id")
        }
        if lastname != nil{
            aCoder.encodeObject(lastname, forKey: "lastname")
        }
        if nicename != nil{
            aCoder.encodeObject(nicename, forKey: "nicename")
        }
        if nickname != nil{
            aCoder.encodeObject(nickname, forKey: "nickname")
        }
        if registered != nil{
            aCoder.encodeObject(registered, forKey: "registered")
        }
        if url != nil{
            aCoder.encodeObject(url, forKey: "url")
        }
        if username != nil{
            aCoder.encodeObject(username, forKey: "username")
        }
        
    }
    
}