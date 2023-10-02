//
//  Extensions.swift
//  Channers
//
//  Created by Rez on 4/14/23.
//

import Foundation

extension String {
    func ChanComFix() -> String {
        var curString = self
        
        ///replace <brs> with \n
        curString = curString.replacingOccurrences(of: "<br>", with: "\n")
        
        ///replace quotes with a quote thing (add a function handler for this at some point)
        let regString = #"(<a href="/[a-z]+/thread/\d*#p\d+" class="quotelink">)>>(\d+)</a>/"#
        let regex = try? NSRegularExpression(pattern: regString)
        
        curString = (regex?.stringByReplacingMatches(in: curString, range: NSRange(0...curString.count-1), withTemplate: "(quote was here)")) ?? "failed to replace"
        
        
        return curString
    }
}


