//
//	Category.swift
//
//	Create by wl on 25/4/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyJSON

class Category : NSObject, NSCoding{

	var descriptionField : String!
	var id : Int!
	var parent : Int!
	var postCount : Int!
	var slug : String!
	var title : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json == nil{
			return
		}
		descriptionField = json["description"].stringValue
		id = json["id"].intValue
		parent = json["parent"].intValue
		postCount = json["post_count"].intValue
		slug = json["slug"].stringValue
		title = json["title"].stringValue
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		var dictionary = NSMutableDictionary()
		if descriptionField != nil{
			dictionary["description"] = descriptionField
		}
		if id != nil{
			dictionary["id"] = id
		}
		if parent != nil{
			dictionary["parent"] = parent
		}
		if postCount != nil{
			dictionary["post_count"] = postCount
		}
		if slug != nil{
			dictionary["slug"] = slug
		}
		if title != nil{
			dictionary["title"] = title
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         descriptionField = aDecoder.decodeObjectForKey("description") as? String
         id = aDecoder.decodeObjectForKey("id") as? Int
         parent = aDecoder.decodeObjectForKey("parent") as? Int
         postCount = aDecoder.decodeObjectForKey("post_count") as? Int
         slug = aDecoder.decodeObjectForKey("slug") as? String
         title = aDecoder.decodeObjectForKey("title") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encodeWithCoder(aCoder: NSCoder)
	{
		if descriptionField != nil{
			aCoder.encodeObject(descriptionField, forKey: "description")
		}
		if id != nil{
			aCoder.encodeObject(id, forKey: "id")
		}
		if parent != nil{
			aCoder.encodeObject(parent, forKey: "parent")
		}
		if postCount != nil{
			aCoder.encodeObject(postCount, forKey: "post_count")
		}
		if slug != nil{
			aCoder.encodeObject(slug, forKey: "slug")
		}
		if title != nil{
			aCoder.encodeObject(title, forKey: "title")
		}

	}

}