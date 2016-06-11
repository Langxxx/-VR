//
//  Result.swift
//  盗梦极客VR
//
//  Created by wl on 4/25/16.
//  Copyright © 2016 wl. All rights reserved.
//  结果

import Foundation

enum Error: ErrorType {
    case NetworkError
    case AccountInvalid
    case RegisterError(String)
    case UserInterrupt
}

enum Result<Value> {
    case Success(Value)
    case Failure(ErrorType)
}

extension Result {
    func map<T>(@noescape f: Value throws -> T) rethrows -> Result<T> {
        switch self {
        case .Success(let v):
            do {
                return .Success(try f(v))
            }catch let e {
                return .Failure(e)
            }
        case .Failure(let e):
            return .Failure(e)
        }
    }
}
extension Result {
    func flatMap<T>(@noescape f: Value throws -> Result<T>) rethrows -> Result<T> {
        switch self {
        case .Success(let v):
            do {
                return try f(v)
            }catch let e {
                return .Failure(e)
            }
        case .Failure(let e):
            return .Failure(e)
        }
    }
}

