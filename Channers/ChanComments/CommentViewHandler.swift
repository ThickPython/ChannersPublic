//
//  CommentTextViews.swift
//  Channers
//
//  Created by Rez on 4/14/23.
//
//  A bunch of text views 

import SwiftUI

///View of a chan comment
class CommentViewHandler {
    ///original text with all the garbage
    var originalText : String
    ///processed text that is less bad
    var proccessedText : String
    ///The components of the channer comment separated into it's individual unique parts
    var commentComponents : [BaseChanSection]
    
    init(comment : String) {
        originalText = comment
        proccessedText = originalText
            .removingHTMLEntities()
            .replacingOccurrences(of: "<br>", with: "\n")
            .replacingOccurrences(of: "<wbr>", with: "")
        commentComponents = []
        commentComponents = extractSections(for: proccessedText)
        
    }
    
    ///Shows the comment as a single text view
    @ViewBuilder func textView() -> some View {
        HStack() {
            componentsAsText
            Spacer()
        }
    }
    
    var componentsAsText : Text {
        var base = Text("")
        commentComponents.forEach({
            section in
            
            base = base + (section as! ChanSectionWithViews).toText()
        })
        
        return base
    }
    
    ///Assembles the comment components
    @ViewBuilder func commentView() -> some View {
        VStack(alignment: .leading) {
            HStack() {
                Spacer()
            }
            ForEach(commentComponents, content: {
                component in
                
                (component as! ChanSectionWithViews).toView().interalView
            })
        }
    }
}

struct CommentTextViews : View {
    let test2 = "last fren >>31220749</a>bin: https://pastebin.com/DEWd0zpPvibe: https://www.youtube.com/watch?v=D_2bluVPsb0minecraft: minetfg.com>qott: Are you strong in the Force?</span>"
    @State var path = NavigationPath()
    let commentView : CommentViewHandler
    @ObservedObject var thread = ThreadHandler.current.LoadThread(forBoard: "lgbt", withID: 31224193)
    
    init() {
        commentView = CommentViewHandler(comment: test2)
        
    }
    
    var body : some View {
        VStack(alignment: .leading) {
            if(thread.canShow) {
                Text(thread.threadData?.op.rawData.com! ?? "no")
                    .onAppear(perform: {print(thread.threadData?.op.rawData.com! ?? "no")})
                Divider()
                Text("text view")
                thread.threadData?.op.commentView.textView()
                    .padding(15)
                    .border(.blue)
                    .padding(15)
                Divider()
                Text("comment view")
                thread.threadData?.op.commentView.commentView()
            } else {
                Text("no")
            }
        }
        
        
    }
}

struct CommentTextViews_Previews: PreviewProvider {
    static var previews: some View {
            CommentTextViews()
    }
}

