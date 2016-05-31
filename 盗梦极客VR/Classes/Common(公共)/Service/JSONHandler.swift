//
//  JSONHandler.swift
//  盗梦极客VR
//
//  Created by wl on 4/25/16.
//  Copyright © 2016 wl. All rights reserved.
//  处理一些JSON的操作

import Foundation
import SwiftyJSON
import Alamofire

protocol JSONToModel {
    init(fromJson json: JSON!)
}
extension NewsModel: JSONToModel {
    
}
extension Category: JSONToModel {
    
}
extension CustomField: JSONToModel {
    
}
extension Tag: JSONToModel {
    
}
extension BBSInfo: JSONToModel {}
extension Participant: JSONToModel {}
extension Post: JSONToModel {}

/**
 获取列表相关新闻数据，
 在首页以及设备详情模块调用
 - parameter urlStr:     请求URL
 - parameter parameters: 参数
 */
func fetchJsonFromNet(urlStr: String, _ parameters: [String: AnyObject]? = nil) -> AsynOperation<JSON> {
    return AsynOperation { completion in
        
        Alamofire.request(.GET, urlStr, parameters: parameters)
            .responseJSON { response in
                guard response.result.error == nil else {
                    dPrint("Alamofire error!")
                    completion(.Failure(Error.NetworkError))
                    return
                }
                
                let value = JSON(response.result.value!)
                completion(.Success(value))
        }
    }
}

/**
 获得首页资讯模块图片轮播器的JSON数据，
 在首页资讯分类加载成功后调用
 
 - parameter otherJson: 资讯分类的JSON

 */
func fetchTopNewsJsonFromNet(otherJson: JSON) -> AsynOperation<[JSON]> {
    return AsynOperation { completion in
        Alamofire.request(.GET, "http://dmgeek.com/DG_api/get_taxonomy_posts/?taxonomy=post_tag&id=167&count=5")
            .responseJSON { response in
                guard response.result.error == nil else {
                    dPrint("Alamofire error!")
                    completion(.Failure(Error.NetworkError))
                    return
                }
                let value = JSON(response.result.value!)
                completion(.Success([otherJson,value]))
        }

    }
}
/**
 JSON转model的便捷方法
 
 - parameter json:    需要转化的JSON数据
 - parameter initial: 模型初始化方法
 
 - returns: 转化好的模型
 */
func jsonToModel<Model: JSONToModel>(json: JSON, initial: (JSON) -> Model) -> Model {
    return initial(json)
}
/**
 JSON转model数组的便捷方法
 
 - parameter json:    需要转化的JSON数据
 - parameter initial: 模型初始化方法
 
 - returns: 转化好的模型数组
 */
func jsonToModelArray<Model: JSONToModel>(json: JSON, initial: (JSON) -> Model) -> [Model] {
    return json.map { _, json in
        initial(json)
    }
}
/**
 JSON转model数组的便捷方法
 
 - parameter jsonArray: 需要转化的JSON数据
 - parameter initial:   模型初始化方法
 
 - returns: 转化好的模型数组
 */
func jsonToModelArray<Model: JSONToModel>(jsonArray: [JSON], initial: (JSON) -> Model) -> [[Model]] {
    return jsonArray.map { jsonToModelArray($0["posts"], initial: initial)}
}
