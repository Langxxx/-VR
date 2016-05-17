//
//  RegexHelper.swift
//  盗梦极客VR
//
//  Created by wl on 5/11/16.
//  Copyright © 2016 wl. All rights reserved.
//

import Foundation

struct RegexHelper {
    
    let regex: NSRegularExpression?
    

    
    init(_ pattern: String) {
        regex = try? NSRegularExpression(pattern: pattern,
                                        options: .CaseInsensitive)
    }
    
    func match(input: String) -> Bool {
        if let matches = regex?.matchesInString(input,
                                            options: [],
                                            range: NSMakeRange(0, input.utf16.count)) {
            
            return matches.count > 0
        }else {
            return false
        }
    }

}

extension RegexHelper {
    
    static func replaceHtml(input: String) throws -> String {
//        let regexStyle = "<[\\s]*?style[^>]*?>[\\s\\S]*?<[\\s]*?\\/[\\s]*?style[\\s]*?>"
//        let regexScript = "<[\\s]*?script[^>]*?>[\\s\\S]*?<[\\s]*?\\/[\\s]*?script[\\s]*?>"
//        let regexSpecial = "\\&[a-zA-Z]{1,10};"
        let regexHtml = "<[^>]+>"
        let regex = try NSRegularExpression(pattern: regexHtml,
                                        options: .CaseInsensitive)
        
        return regex.stringByReplacingMatchesInString(input, options: [], range: NSMakeRange(0, input.characters.count), withTemplate: "")
    }
}