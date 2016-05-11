//
//	Participant.swift
//
//	Create by wl on 11/5/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyJSON

class Participant : NSObject, NSCoding{

	var avatarTemplate : String!
	var id : Int!
	var username : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	required init(fromJson json: JSON!){
		if json == nil{
			return
		}
		avatarTemplate = json["avatar_template"].stringValue
		id = json["id"].intValue
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
		if id != nil{
			dictionary["id"] = id
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
         id = aDecoder.decodeObjectForKey("id") as? Int
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
		if id != nil{
			aCoder.encodeObject(id, forKey: "id")
		}
		if username != nil{
			aCoder.encodeObject(username, forKey: "username")
		}

	}

}