//
//  AsynOperation.swift
//  盗梦极客VR
//
//  Created by wl on 4/25/16.
//  Copyright © 2016 wl. All rights reserved.
//  异步操作

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
