//
//  BuilderExtensions.swift
//  Channers
//
//  Created by Rez on 4/20/23.
//

import Foundation
import SwiftUI


//big builders
extension PostPreview {
    //builds the top section where number is
    @ViewBuilder func bigHeaderBuilder() -> some View {
        HStack() {
            HStack() {
                //number
                Text(String(OPPost.rawData.no ?? -1))
                Divider()
                //name
                Text(String(OPPost.rawData.name ?? "no name?"))
                    .frame(maxWidth: 150)
                Divider()
                PostActionsMenu()
                    .shareComment(is: OPPost.rawData.com)
                    .shareSubject(is: OPPost.rawData.sub)
                    .sharePostLink(is: OPPost.GetPostURL())
                    .bookmarkableThread(opPost: OPPost)
            }
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 15)
                .foregroundColor(theme.foreground))
            Spacer()
        }
        .fixedSize()
    }
    
    //builds the attachment
    @ViewBuilder func bigAttachmentBuilder() -> some View {
        //attachment
        if !OPPost.hasAttachment {
            EmptyView()
        } else {
            ZStack() {
                if(OPPost.hdAttachmentLoaded) {
                    Image(uiImage: OPPost.hdAttachment!)
                        .resizable()
                        .scaledToFill()
                        .frame(maxHeight:300)
                        .clipped()
                        .contentShape(Rectangle())
                        .mask(RoundedRectangle(cornerRadius: 15))
                } else {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(height: min(300, CGFloat(OPPost.rawData.h!)))
                }
                if(settings.showFileName) {
                    //Filename
                    VStack() {
                        Spacer()
                        HStack() {
                            Text(OPPost.GetFileName())
                                .font(SwiftUI.Font.footnote)
                                .lineLimit(1)
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(theme.background.opacity(0.7))
                                    .shadow(radius: 3))
                            Spacer()
                        }
                    }
                    .padding(7)
                }
            }
        }
    }
    
    //builds the content view of the catagory preview
    @ViewBuilder func bigContentBuilder() -> some View {
        //Text portion + details
        VStack() {
            //subject
            if(OPPost.rawData.sub != nil) {
                HStack() {
                    Text(OPPost.GetSubject())
                        .bold()
                    Spacer()
                }
                Divider()
            }
            
            VStack() {
                //text
                if(OPPost.rawData.com != nil) {
                    HStack() {
                        OPPost.GetCommentTextView()
                            .multilineTextAlignment(.leading)
                            .frame(maxHeight: 150)
                        Spacer(minLength: 0)
                    }
                    Divider()
                }
                
                //details
                HStack() {
                    //date
                    Text(dateStyler.string(from: OPPost.GetDatePosted()))
                    Spacer()
                    //# of replies
                    Label(String(OPPost.rawData.replies ?? -1), systemImage: "message")
                    BookmarkButton(board: OPPost.board, threadID: OPPost.rawData.no!)
                }
            }
            
        }
        .frame(maxWidth: .infinity)
        .padding(15)
        .background(RoundedRectangle(cornerRadius: 15)
            .foregroundColor(theme.foreground))
    }
}

//compact builders
extension PostPreview {
    ///Builds the compact id and name
    @ViewBuilder func CompactNameID() -> some View {
        HStack() {
            Text(String(OPPost.rawData.no!))
                .bold()
                .foregroundColor(theme.primary)
            Divider()
            Text(OPPost.rawData.name!)
                .bold()
                .foregroundColor(theme.primary)
            Divider()
            PostActionsMenu()
                .shareComment(is: OPPost.rawData.com)
                .shareSubject(is: OPPost.rawData.sub)
                .sharePostLink(is: OPPost.GetPostURL())
            Spacer()
        }
    }
    
    @ViewBuilder func CompactAttachment() -> some View {
        if(OPPost.tnAttachmentLoaded) {
            Image(uiImage: OPPost.tnAttachment!)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .mask(RoundedRectangle(cornerRadius: 15)
                    .frame(width: 100, height: 100))
        } else {
            RoundedRectangle(cornerRadius: 15)
                .frame(width: 100, height: 100)
        }
    }
    
    @ViewBuilder func CompactContent() -> some View {
        VStack() {
            if(OPPost.rawData.sub != nil) {
                HStack() {
                    Text(OPPost.rawData.sub!)
                        .bold()
                        .lineLimit(1)
                        .foregroundColor(theme.primary)
                    Spacer()
                }
            }
            if(OPPost.rawData.com != nil) {
                HStack() {
                    OPPost.GetCommentTextView()
                        .lineLimit(3)
                        .foregroundColor(theme.primary)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
            }
        }
    }
    
    @ViewBuilder func CompactDetails() -> some View {
        HStack() {
            Text(dateStyler.string(from: OPPost.GetDatePosted()))
            Divider()
            Label(String(OPPost.rawData.replies ?? 0), systemImage: "message")
            BookmarkButton(board: OPPost.board, threadID: OPPost.rawData.no!)
            Spacer()
        }
        .foregroundColor(theme.primary)
        .fixedSize(horizontal: false, vertical: true)
    }
}

//imageonly builders
extension PostPreview {
    
}

struct PostPreviewModifier : ViewModifier {
    var theme : ChannerTheme
    
    func body(content: Content) -> some View {
        content
            .padding(10)
            .background(
                LinearGradient(colors: [theme.accentColor, theme.offColor, theme.accentColor], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .cornerRadius(15))
    }
}

extension View {
    func postPreviewModifier(withTheme : ChannerTheme) -> some View {
        modifier(PostPreviewModifier(theme: withTheme))
    }
}
