//
//	BbsInfo.swift
//
//	Create by wl on 11/5/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyJSON

class BBSInfo : NSObject, NSCoding{

	var filteredPostsCount : Int!
	var id : Int!
	var participants : [Participant]!
	var posts : [Post]!
	var postsCount : Int!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	required init(fromJson json: JSON!){
		if json == nil{
			return
		}
		filteredPostsCount = json["filtered_posts_count"].intValue
		id = json["id"].intValue
		participants = [Participant]()
		let participantsArray = json["participants"].arrayValue
		for participantsJson in participantsArray{
			let value = Participant(fromJson: participantsJson)
			participants.append(value)
		}
		posts = [Post]()
		let postsArray = json["posts"].arrayValue
		for postsJson in postsArray{
			let value = Post(fromJson: postsJson)
			posts.append(value)
		}
		postsCount = json["posts_count"].intValue
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if filteredPostsCount != nil{
			dictionary["filtered_posts_count"] = filteredPostsCount
		}
		if id != nil{
			dictionary["id"] = id
		}
		if participants != nil{
			var dictionaryElements = [NSDictionary]()
			for participantsElement in participants {
				dictionaryElements.append(participantsElement.toDictionary())
			}
			dictionary["participants"] = dictionaryElements
		}
		if posts != nil{
			var dictionaryElements = [NSDictionary]()
			for postsElement in posts {
				dictionaryElements.append(postsElement.toDictionary())
			}
			dictionary["posts"] = dictionaryElements
		}
		if postsCount != nil{
			dictionary["posts_count"] = postsCount
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         filteredPostsCount = aDecoder.decodeObjectForKey("filtered_posts_count") as? Int
         id = aDecoder.decodeObjectForKey("id") as? Int
         participants = aDecoder.decodeObjectForKey("participants") as? [Participant]
         posts = aDecoder.decodeObjectForKey("posts") as? [Post]
         postsCount = aDecoder.decodeObjectForKey("posts_count") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encodeWithCoder(aCoder: NSCoder)
	{
		if filteredPostsCount != nil{
			aCoder.encodeObject(filteredPostsCount, forKey: "filtered_posts_count")
		}
		if id != nil{
			aCoder.encodeObject(id, forKey: "id")
		}
		if participants != nil{
			aCoder.encodeObject(participants, forKey: "participants")
		}
		if posts != nil{
			aCoder.encodeObject(posts, forKey: "posts")
		}
		if postsCount != nil{
			aCoder.encodeObject(postsCount, forKey: "posts_count")
		}

	}

}