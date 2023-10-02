//
//  ComponentTypes.swift
//  Channers
//
//  Created by Rez on 5/31/23.
//

import Foundation
import SwiftUI

extension CommentViewHandler {
    
    ///Plain text, just normal text, anything not regexed
    class Plain : BaseChanSection, ChanSectionWithViews {
        var text : String
        init(text: String, range : NSRange) {
            self.text = (text as NSString).substring(with: range)
            super.init()
            setBounds(range.lowerBound, range.upperBound)
        }
        
        func toText() -> Text {
            Text(text)
                .foregroundColor(ColorSettings.current.primary)
        }
        
        func toView() -> ViewComponent {
            ViewComponent(toText())
        }
    }
    
    class Italic : BaseChanSection, ChanSectionWithViews {
        var text : String
        static var pattern = try! NSRegularExpression(pattern: #"<i>(.+)</i>"#)
        init(with regexResult : NSTextCheckingResult, for comment : String) {
            self.text = (comment as NSString).substring(with: regexResult.range(at: 1))
            super.init()
            setBounds(regexResult: regexResult)
        }
        
        func toText() -> Text {
            Text(text)
                .italic()
                .foregroundColor(ColorSettings.current.activeTheme.primary)
        }
        
        func toView() -> ViewComponent {
            ViewComponent(toText())
        }
    }
    
    class Bold : BaseChanSection, ChanSectionWithViews {
        var text : String
        static var pattern = try! NSRegularExpression(pattern: #"<b>(.+)</b>"#)
        init(with regexResult : NSTextCheckingResult, for comment : String) {
            self.text = (comment as NSString).substring(with: regexResult.range(at: 1))
            super.init()
            setBounds(regexResult: regexResult)
        }
        
        func toText() -> Text {
            Text(text)
                .bold()
                .foregroundColor(ColorSettings.current.primary)
        }
        
        func toView() -> ViewComponent {
            ViewComponent(toText())
        }
    }
    

    ///Normal 4chan quote like
    /// >mfw
    /// >be mw
    class Quote : BaseChanSection, ChanSectionWithViews {
        var quoteText : String
        static var pattern = try! NSRegularExpression(
            pattern: #"<span class=\"quote\"(.+)</span>"#)
        
        init(with regexResult : NSTextCheckingResult, for comment : String) {
            quoteText = (comment as NSString).substring(with: regexResult.range(at: 1))
            super.init()
            setBounds(regexResult: regexResult)
        }
        
        func toText() -> Text {
            Text(quoteText)
                .foregroundColor(.green)
        }
        
        func toView() -> ViewComponent {
            ViewComponent(toText())
        }
    }
    
    ///4chan quote response
    ///>>5091874315
    ///   you're silly for that
    class QuoteLink : BaseChanSection, ChanSectionWithViews {
        var displayAs : String
        var quoteID : Int
        static var pattern = try! NSRegularExpression(
            pattern: ##"<a href=\"#p(\d+)\" class=\"quotelink\">>>(\d+)</a>"##)
        
        init(with regexResult : NSTextCheckingResult, for comment : String) {
            quoteID = Int((comment as NSString).substring(with: regexResult.range(at: 1)))!
            displayAs = ">>\(quoteID)"
            super.init()
            setBounds(regexResult: regexResult)
        }
        
        func toText() -> Text {
            Text(displayAs)
                .foregroundColor(.orange)
        }
        
        func toView() -> ViewComponent {
            ViewComponent(
                QuoteLinkRoot(quoteTo: quoteID)
            )
        }
    }
    
    //Links externaly
    class ExternalLink : BaseChanSection, ChanSectionWithViews {
        var linkTo : String
        var displayAs : String
        static var pattern = try! NSRegularExpression(
            pattern: #"<a href=\"([^ ]+)\">([^ ]+)</a>"#)
        
        init(with regexResult : NSTextCheckingResult, for comment : String) {
            linkTo = (comment as NSString).substring(with: regexResult.range(at: 1))
            displayAs = (comment as NSString).substring(with: regexResult.range(at: 2))
            super.init()
            setBounds(regexResult: regexResult)
        }
        
        func toText() -> Text {
            Text(displayAs)
                .underline(true)
                .foregroundColor(.blue)
        }
        
        func toView() -> ViewComponent {
            ViewComponent(toText())
        }
    }

    ///External link but it's dead
    class DeadLink : BaseChanSection, ChanSectionWithViews {
        var linkTo : String
        var displayAs : String
        static var pattern = try! NSRegularExpression(
            pattern: #"<a href=\"([^ ]+)\" class=\"deadlink\">>>(\d+)</a>"#)
        
        init(with regexResult : NSTextCheckingResult, for comment : String) {
            linkTo = (comment as NSString).substring(with: regexResult.range(at: 1))
            displayAs = (comment as NSString).substring(with: regexResult.range(at: 2))
            super.init()
            setBounds(regexResult: regexResult)
        }
        
        func toText() -> Text {
            Text(displayAs)
                .strikethrough(true)
                .foregroundColor(.red)
        }
        
        func toView() -> ViewComponent {
            ViewComponent(toText())
        }
    }

    ///Quotelink but it's dead
    class QuoteDeadLink : BaseChanSection, ChanSectionWithViews {
        var deadQuoteID : String
        var displayAs : String
        static var pattern = try! NSRegularExpression(
            pattern: #"<span class=\"deadlink\">>>(\d+)</span>"#)
        
        init(with regexResult : NSTextCheckingResult, for comment : String) {
            deadQuoteID = (comment as NSString).substring(with: regexResult.range(at: 1))
            displayAs = ">>\(deadQuoteID)"
            super.init()
            setBounds(regexResult: regexResult)
        }
        
        func toText() -> Text {
            Text(displayAs)
                .strikethrough(true)
                .foregroundColor(.red)
        }
        
        func toView() -> ViewComponent {
            ViewComponent(toText())
        }
    }
    
    ///I don't know if these will ever show up so don't use them until they do
    /*

    ///Links to a board
    class BoardLink : BaseChanSection, ChanSectionWithViews {
        var board : String
        var displayAs : String
        static var patternFor = try! NSRegularExpression(
                pattern: #"<a href=\"//boards.4chan.org/(\w+)/\" class=\"quotelink\">>>(.*)</a>"#)
        
        init(with regexResult : NSTextCheckingResult, for comment : String) {
            board = (comment as NSString).substring(with: result.range(at: 1))
            displayAs = (comment as NSString).substring(with: result.range(at: 2))
            setBounds(regexResult: result)
        }
        
        func toText() -> Text {
            <#code#>
        }
        
        func toView() -> ViewComponent {
            <#code#>
        }
    }*/
     
    //A quote link but instead of to a comment in the thread
    //It's to an entirely other post
    class QuotePostLink : BaseChanSection, ChanSectionWithViews {
        var board : String
        var threadID : String
        var replyID : String
        var displayAs : String
        static var pattern = try! NSRegularExpression(
            pattern: ##"<a href="/(\w+)/thread/(\d+)#p(\d+)\" class=\"quotelink\">>>(\d+)</a>"##)
        
        
        init(with result : NSTextCheckingResult, for comment : String) {
            board = (comment as NSString).substring(with: result.range(at: 1))
            threadID = (comment as NSString).substring(with: result.range(at: 2))
            replyID = (comment as NSString).substring(with: result.range(at: 3))
            displayAs = ">>\((comment as NSString).substring(with: result.range(at: 4)))"
            super.init()
            setBounds(regexResult: result)
        }
        
        func toText() -> Text {
            Text(displayAs)
                .foregroundColor(Color(uiColor: .orange))
        }
        
        func toView() -> ViewComponent {
            ViewComponent(toText())
        }
    }
}
