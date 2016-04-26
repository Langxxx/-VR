//
//	CustomField.swift
//
//	Create by wl on 25/4/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyJSON


class CustomField : NSObject, NSCoding{

    	/// 评论总数
	var discourseCommentsCount : [String]!
        /// 评论内容
	var discourseCommentsRaw : [String]!
    
    /********** 暂时没用 ************/
	var discourseLastSync : [String]!
	var discoursePermalink : [String]!
	var discoursePostId : [String]!
	var gameszoneTfusePostOptions : [String]!
	var posturlAddUrl : [String]!
	var publishPostCategory : [String]!
	var publishToDiscourse : [String]!
	var qqworldautosaveimagespostsscanned : [String]!
	var views : [String]!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	required init(fromJson json: JSON!){
		if json == nil{
			return
		}
		discourseCommentsCount = [String]()
		let discourseCommentsCountArray = json["discourse_comments_count"].arrayValue
		for discourseCommentsCountJson in discourseCommentsCountArray{
			discourseCommentsCount.append(discourseCommentsCountJson.stringValue)
		}
		discourseCommentsRaw = [String]()
		let discourseCommentsRawArray = json["discourse_comments_raw"].arrayValue
		for discourseCommentsRawJson in discourseCommentsRawArray{
			discourseCommentsRaw.append(discourseCommentsRawJson.stringValue)
		}
		discourseLastSync = [String]()
		let discourseLastSyncArray = json["discourse_last_sync"].arrayValue
		for discourseLastSyncJson in discourseLastSyncArray{
			discourseLastSync.append(discourseLastSyncJson.stringValue)
		}
		discoursePermalink = [String]()
		let discoursePermalinkArray = json["discourse_permalink"].arrayValue
		for discoursePermalinkJson in discoursePermalinkArray{
			discoursePermalink.append(discoursePermalinkJson.stringValue)
		}
		discoursePostId = [String]()
		let discoursePostIdArray = json["discourse_post_id"].arrayValue
		for discoursePostIdJson in discoursePostIdArray{
			discoursePostId.append(discoursePostIdJson.stringValue)
		}
		gameszoneTfusePostOptions = [String]()
		let gameszoneTfusePostOptionsArray = json["gameszone_tfuse_post_options"].arrayValue
		for gameszoneTfusePostOptionsJson in gameszoneTfusePostOptionsArray{
			gameszoneTfusePostOptions.append(gameszoneTfusePostOptionsJson.stringValue)
		}
		posturlAddUrl = [String]()
		let posturlAddUrlArray = json["posturl_add_url"].arrayValue
		for posturlAddUrlJson in posturlAddUrlArray{
			posturlAddUrl.append(posturlAddUrlJson.stringValue)
		}
		publishPostCategory = [String]()
		let publishPostCategoryArray = json["publish_post_category"].arrayValue
		for publishPostCategoryJson in publishPostCategoryArray{
			publishPostCategory.append(publishPostCategoryJson.stringValue)
		}
		publishToDiscourse = [String]()
		let publishToDiscourseArray = json["publish_to_discourse"].arrayValue
		for publishToDiscourseJson in publishToDiscourseArray{
			publishToDiscourse.append(publishToDiscourseJson.stringValue)
		}
		qqworldautosaveimagespostsscanned = [String]()
		let qqworldautosaveimagespostsscannedArray = json["qqworld-auto-save-images-posts-scanned"].arrayValue
		for qqworldautosaveimagespostsscannedJson in qqworldautosaveimagespostsscannedArray{
			qqworldautosaveimagespostsscanned.append(qqworldautosaveimagespostsscannedJson.stringValue)
		}
		views = [String]()
		let viewsArray = json["views"].arrayValue
		for viewsJson in viewsArray{
			views.append(viewsJson.stringValue)
		}
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if discourseCommentsCount != nil{
			dictionary["discourse_comments_count"] = discourseCommentsCount
		}
		if discourseCommentsRaw != nil{
			dictionary["discourse_comments_raw"] = discourseCommentsRaw
		}
		if discourseLastSync != nil{
			dictionary["discourse_last_sync"] = discourseLastSync
		}
		if discoursePermalink != nil{
			dictionary["discourse_permalink"] = discoursePermalink
		}
		if discoursePostId != nil{
			dictionary["discourse_post_id"] = discoursePostId
		}
		if gameszoneTfusePostOptions != nil{
			dictionary["gameszone_tfuse_post_options"] = gameszoneTfusePostOptions
		}
		if posturlAddUrl != nil{
			dictionary["posturl_add_url"] = posturlAddUrl
		}
		if publishPostCategory != nil{
			dictionary["publish_post_category"] = publishPostCategory
		}
		if publishToDiscourse != nil{
			dictionary["publish_to_discourse"] = publishToDiscourse
		}
		if qqworldautosaveimagespostsscanned != nil{
			dictionary["qqworld-auto-save-images-posts-scanned"] = qqworldautosaveimagespostsscanned
		}
		if views != nil{
			dictionary["views"] = views
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         discourseCommentsCount = aDecoder.decodeObjectForKey("discourse_comments_count") as? [String]
         discourseCommentsRaw = aDecoder.decodeObjectForKey("discourse_comments_raw") as? [String]
         discourseLastSync = aDecoder.decodeObjectForKey("discourse_last_sync") as? [String]
         discoursePermalink = aDecoder.decodeObjectForKey("discourse_permalink") as? [String]
         discoursePostId = aDecoder.decodeObjectForKey("discourse_post_id") as? [String]
         gameszoneTfusePostOptions = aDecoder.decodeObjectForKey("gameszone_tfuse_post_options") as? [String]
         posturlAddUrl = aDecoder.decodeObjectForKey("posturl_add_url") as? [String]
         publishPostCategory = aDecoder.decodeObjectForKey("publish_post_category") as? [String]
         publishToDiscourse = aDecoder.decodeObjectForKey("publish_to_discourse") as? [String]
         qqworldautosaveimagespostsscanned = aDecoder.decodeObjectForKey("qqworld-auto-save-images-posts-scanned") as? [String]
         views = aDecoder.decodeObjectForKey("views") as? [String]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encodeWithCoder(aCoder: NSCoder)
	{
		if discourseCommentsCount != nil{
			aCoder.encodeObject(discourseCommentsCount, forKey: "discourse_comments_count")
		}
		if discourseCommentsRaw != nil{
			aCoder.encodeObject(discourseCommentsRaw, forKey: "discourse_comments_raw")
		}
		if discourseLastSync != nil{
			aCoder.encodeObject(discourseLastSync, forKey: "discourse_last_sync")
		}
		if discoursePermalink != nil{
			aCoder.encodeObject(discoursePermalink, forKey: "discourse_permalink")
		}
		if discoursePostId != nil{
			aCoder.encodeObject(discoursePostId, forKey: "discourse_post_id")
		}
		if gameszoneTfusePostOptions != nil{
			aCoder.encodeObject(gameszoneTfusePostOptions, forKey: "gameszone_tfuse_post_options")
		}
		if posturlAddUrl != nil{
			aCoder.encodeObject(posturlAddUrl, forKey: "posturl_add_url")
		}
		if publishPostCategory != nil{
			aCoder.encodeObject(publishPostCategory, forKey: "publish_post_category")
		}
		if publishToDiscourse != nil{
			aCoder.encodeObject(publishToDiscourse, forKey: "publish_to_discourse")
		}
		if qqworldautosaveimagespostsscanned != nil{
			aCoder.encodeObject(qqworldautosaveimagespostsscanned, forKey: "qqworld-auto-save-images-posts-scanned")
		}
		if views != nil{
			aCoder.encodeObject(views, forKey: "views")
		}

	}

}