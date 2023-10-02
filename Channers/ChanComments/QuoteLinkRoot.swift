//
//  CommentView.swift
//  Channers
//
//  Created by Rez on 5/31/23.
//
//  Creates the quotelink view
//  looks like it's just ">>3925782375"
//  but when you click on it it all appears

import SwiftUI

///Root of a quote link
struct QuoteLinkRoot: View {
    @EnvironmentObject var thread : ThreadObj
    @EnvironmentObject var theme : ColorSettings
    var quoteTo : Int
    @State var showParent : Bool = false
    
    init(quoteTo : Int) {
        self.quoteTo = quoteTo
    }
    
    ///check if reply is op
    var replyIsOP : Bool {
        thread.threadData?.op.rawData.no == quoteTo
    }
 
    var body: some View {
        VStack(alignment: .leading) {
            if(replyIsOP) {
                Text(">>OP")
                    .padding(5)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.gray.opacity(0.2)))
            } else {
                if(showParent) {
                    VStack(alignment: .leading) {
                        QuoteLinkReplies(replyNo: quoteTo, selfCloseControl: $showParent)
                            .transition(.slide)
                    }
                }
                Button(action: {
                    withAnimation {
                        showParent = true
                    }
                }) {
                    Text(">>" + String(quoteTo))
                        .foregroundColor(theme.primary)
                        .padding(5)
                        .background(RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.gray.opacity(0.2)))
                }
            }
        }
    }
}

///Posts that a quotelink replies to
///Further replies open in a vstack rather than nesting further
///Not the same as a normal reply view because opening views doesn't open nested
///But rather stacked on top
struct QuoteLinkReplies: View {
    @State var postToShow : Int = -1
    @EnvironmentObject var thread : ThreadObj
    
    ///thread id of this post
    var replyNo : Int
    
    ///toggle this to close self
    @Binding var selfCloseControl : Bool
    
    ///replies to this (above) toggle this to close themselves
    @State var parentCloseControl : Bool = false
    
    ///the post in question
    var replyPost : ChanPost? {
        thread.threadData?.postIndex[replyNo]
    }
    
    ///OP post
    var threadOP : ChanPost? {
        thread.threadData?.op
    }
    
    ///Post to show chanpost
    var postToShowPost : ChanPost? {
        thread.threadData?.postIndex[postToShow]
    }
    
    var body : some View {
        VStack(alignment: .leading) {
            //reply parent
            if(postToShow > -1) {
                VStack(alignment: .leading) {
                    QuoteLinkReplies(replyNo: postToShow, selfCloseControl: $parentCloseControl)
                        .onChange(of: parentCloseControl, perform: { reply in
                            
                            withAnimation {
                                postToShow = -1
                            }
                        })
                        .transition(.slide)
                }
            }
            
            //reply itself
            VStack(alignment: .leading) {
                ForEach(replyPost?.commentView.commentComponents ?? [], content: {
                    component in
                    
                    if(component is CommentViewHandler.QuoteLink) {
                        //if quoting OP
                        if((component as! CommentViewHandler.QuoteLink).quoteID == threadOP?.rawData.no ?? -1) {
                            Text(">>OP")
                                .padding(5)
                                .background(RoundedRectangle(cornerRadius: 5)
                                    .foregroundColor(.gray.opacity(0.1)))
                        }
                        //if not quoting OP
                        else {
                            QuoteLinkReplyButton(postToShow: $postToShow, replyNo: (component as! CommentViewHandler.QuoteLink).quoteID)
                        }
                    } else {
                        (component as! ChanSectionWithViews).toView()
                            .interalView
                            .fixedSize(horizontal: false, vertical: true)
                    }
                })
                HStack() {
                    Text(String(replyPost?.rawData.name ?? "Anonymous?"))
                    Button(action: {
                        withAnimation{
                            selfCloseControl.toggle()
                        }
                    }, label: {
                        Label("Close", systemImage: "x.circle.fill")
                            .labelStyle(.iconOnly)
                            .font(.title2)
                            .foregroundColor(.secondary)
                    })
                    
                    Spacer()
                }
                .padding([.top])
            }
            .padding(15)
            .background(RoundedRectangle(cornerRadius: 15)
                .foregroundColor(.gray.opacity(0.1)))
        }
    }
}

///a further reply button in a quotelink parent
///Does not create a nested view but binds to the parent
struct QuoteLinkReplyButton: View {
    @EnvironmentObject var theme : ColorSettings
    @Binding var postToShow : Int
    var replyNo : Int
    
    var body : some View {
        Button(action: {
            postToShow = replyNo
        }) {
            Text(">>" + String(replyNo))
                .padding(5)
                .foregroundColor(theme.primary)
                .background(RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.gray.opacity(0.2)))
        }
    }
}

struct QuoteLinkRoot_Preview: PreviewProvider {
    static var previews: some View {
        ThreadViewDebug()
    }
}

struct QuoteLinkViewDebug : View {
    @StateObject var thread = ThreadHandler.current.LoadThread(forBoard: "lgbt", withID: 3801380)
    
    
    var body: some View {
        ScrollView() {
            if(thread.canShow) {
                thread.threadData?.postIndex[3801401]?.GetCommentView()
                    .environmentObject(thread)
                
            } else {
                Text("fail")
            }
        }
    }
}
