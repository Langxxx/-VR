//
//  JSONHandler.swift
//  盗梦极客VR
//
//  Created by wl on 4/25/16.
//  Copyright © 2016 wl. All rights reserved.
//

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
func fetchJsonFromNet(urlStr: String, _ parameters: [String: AnyObject]? = nil) -> AsynOperation<JSON> {
    return AsynOperation { completion in
        
        Alamofire.request(.GET, urlStr, parameters: parameters)
            .responseJSON { response in
                guard response.result.error == nil else {
                    print("Alamofire error!")
                    completion(.Failure(Error.NetworkError))
                    return
                }
                
                let value = JSON(response.result.value!)
                completion(.Success(value))
        }
    }
}

func jsonToModel<Model: JSONToModel>(json: JSON, initial: (JSON) -> Model) -> Model {
    return initial(json)
}

func jsonToModelArray<Model: JSONToModel>(json: JSON, initial: (JSON) -> Model) -> [Model] {
    return json.map { _, json in
        initial(json)
    }
}


