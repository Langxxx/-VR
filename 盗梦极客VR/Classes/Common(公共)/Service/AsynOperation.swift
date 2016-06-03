//
//  AsynOperation.swift
//  盗梦极客VR
//
//  Created by wl on 4/25/16.
//  Copyright © 2016 wl. All rights reserved.
//  异步操作

import Foundation
import Alamofire
import SwiftyJSON

struct AsynOperation<T> {
    
    typealias ResultType = Result<T>
    typealias Completion = ResultType -> ()
    typealias Operation = Completion -> ()
    
    let operation: Operation
}

extension AsynOperation {
    func map<U>(f: T throws -> U) rethrows -> AsynOperation<U> {
        return AsynOperation<U> { completion in
            self.operation { result in
                do {
                    completion( try result.map(f))
                }catch let e {
                    completion(.Failure(e))
                }

            }
        }
    }
}

extension AsynOperation {
    // flatMap
    func then<U>(f: T throws -> AsynOperation<U>) -> AsynOperation<U> {
        return AsynOperation<U> { completion in
            self.operation { result in
                switch result {
                case .Success(let v):
                    do {
                        try f(v).operation(completion)
                    }catch let e {
                        completion(.Failure(e))
                    }
                case .Failure(let e):
                    completion(.Failure(e))
                }
            }
            
        }
    }
}

extension AsynOperation {
    func complete(success success: T -> (), failure: ErrorType -> ()) {
        self.operation { result in
            switch result {
            case .Success(let v):
                success(v)
            case .Failure(let e):
                failure(e)
            }
        }
    }
}
// TODO: 这里用扩展XCODE会崩溃...
func networkRequest(urlStr: String,
                    parameters: [String: AnyObject]? = nil,
                    debugNotice: String = "Alamofire error!"
    ) -> AsynOperation<JSON> {
    
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

