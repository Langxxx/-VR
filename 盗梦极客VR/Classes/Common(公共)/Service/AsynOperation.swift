//
//  AsynOperation.swift
//  盗梦极客VR
//
//  Created by wl on 4/25/16.
//  Copyright © 2016 wl. All rights reserved.
//

import Foundation

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
