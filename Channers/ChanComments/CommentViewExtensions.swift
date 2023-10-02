//
//  NewCommentSystem.swift
//  Channers
//
//  Created by Rez on 5/31/23.
//

import Foundation
import SwiftUI

extension CommentViewHandler {
    func extractSections(for comment : String) -> [BaseChanSection] {
        var baseSections : [BaseChanSection] = []
        let searchRange = NSRange(0..<comment.count)
        
        fillComponents()
        
        baseSections.sort()
        
        guard !baseSections.isEmpty else {
            baseSections
                .append(Plain(text: comment, range: NSRange(0..<comment.count)))
            return baseSections
        }
        
        fillBlanks()
        baseSections.sort()
        
        return baseSections
        
        //Adds special non-plain components
        func fillComponents() {
            Italic.pattern.matches(in: comment, range: searchRange).forEach({ result in
                baseSections.append(Italic(with: result, for: comment))
            })
            
            Bold.pattern.matches(in: comment, range: searchRange).forEach({ result in
                baseSections.append(Bold(with: result, for: comment))
            })
            
            Quote.pattern.matches(in: comment, range: searchRange).forEach({ result in
                baseSections.append(Quote(with: result, for: comment))
            })
            
            QuoteLink.pattern.matches(in: comment, range: searchRange).forEach({ result in
                baseSections.append(QuoteLink(with: result, for: comment))
            })
            
            ExternalLink.pattern.matches(in: comment, range: searchRange).forEach({ result in
                baseSections.append(ExternalLink(with: result, for: comment))
            })
            
            DeadLink.pattern.matches(in: comment, range: searchRange).forEach({ result in
                baseSections.append(DeadLink(with: result, for: comment))
            })
            
            QuoteDeadLink.pattern.matches(in: comment, range: searchRange).forEach({ result in
                baseSections.append(QuoteDeadLink(with: result, for: comment))
            })
            
            QuotePostLink.pattern.matches(in: comment, range: searchRange).forEach({ result in
                baseSections.append(QuotePostLink(with: result, for: comment))
            })
        }
        //Fills in all non-special areas
        func fillBlanks() {
            var plainComponents : [BaseChanSection] = []
            
            //if there is text at beginning
            if baseSections.first!.lowerBound > 0 {
                plainComponents.append(Plain(
                    text: comment,
                    range: NSRange(0..<baseSections.first!.lowerBound))
                )
            }
            
            //fill in middle
            for i in (1..<baseSections.count) {
                let lowerSec = baseSections[i-1]
                let upperSec = baseSections[i]
                
                guard lowerSec.upperBound < upperSec.lowerBound else {
                    continue
                }
                
                plainComponents.append(Plain(
                    text: comment,
                    range: NSRange(lowerSec.upperBound..<upperSec.lowerBound))
                )
            }
            
            //if there is text at ending
            if baseSections.last!.upperBound < comment.count {
                plainComponents.append(Plain(
                    text: comment,
                    range: NSRange(baseSections.last!.upperBound..<comment.count))
                )
            }
            
            baseSections.append(contentsOf: plainComponents)
        }
    }
    
}


///supporting types
extension CommentViewHandler {
    
    ///A view section that gets put together in a vstack
    ///To form a comment
    ///Represents a view component of a channer comment
    struct ViewComponent : Identifiable {
        var id = UUID()
        var view : Any
        var interalView : AnyView
        var ownLine : Bool
        
        init<V: View>(_ view : V, ownLine : Bool = false) {
            self.view = view
            interalView = AnyView(view)
            self.ownLine = ownLine
        }
        
        mutating func replaceView<V: View>(_ view : V) {
            self.view = view
            interalView = AnyView(view)
        }
    }
    
    ///Represents a section of a 4chan comment
    ///DO NOT INSTANTIATE
    class BaseChanSection : ChanSection {
        var id = UUID()
        var lowerBound : Int = -1
        var upperBound : Int = -1
        
        static func < (lhs: BaseChanSection, rhs: BaseChanSection) -> Bool {
            return lhs.upperBound-1 < rhs.lowerBound
        }
        
        static func == (lhs: BaseChanSection, rhs: BaseChanSection) -> Bool {
            return (lhs.lowerBound == rhs.upperBound) && (lhs.upperBound == rhs.upperBound)
        }
        
        ///Sets the bounds of the section
        func setBounds(_ lower : Int, _ upper : Int) {
            lowerBound = lower
            upperBound = upper
        }
        
        ///Sets the bounds of the chan section
        func setBounds(regexResult : NSTextCheckingResult) {
            lowerBound = regexResult.range(at: 0).lowerBound
            upperBound = regexResult.range(at: 0).upperBound
        }
    }
}

///A section of a chan comment
///plain/italitc/etc
protocol ChanSection : Comparable, Identifiable {
    var id : UUID { get }
    var lowerBound : Int { get set } ///lower bound of where this section is in the string of the comment
    var upperBound : Int { get set } ///upper bound of where this section is in the string of the comment
    
    func setBounds(_ lower : Int, _ upper : Int)
    func setBounds(regexResult : NSTextCheckingResult)
}

protocol ChanSectionWithViews {
    
    ///Returns this section as a text section
    func toText() -> Text
    
    ///Returns this section as a view
    func toView() -> CommentViewHandler.ViewComponent
}
