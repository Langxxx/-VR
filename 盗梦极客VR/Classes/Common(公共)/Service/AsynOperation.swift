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
    func map<U>(f: T -> U) -> AsynOperation<U> {
        return AsynOperation<U> { completion in
            self.operation { result in
                completion(result.map(f))
            }
        }
    }
}
