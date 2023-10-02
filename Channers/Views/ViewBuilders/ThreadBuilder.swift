//
//  ThreadBuilder.swift
//  Channers
//
//  Created by Rez on 5/1/23.
//
//  Builds views used when inspecting threads

import Foundation
import SwiftUI

extension ThreadView {
    struct ThreadOP : View {
        @EnvironmentObject var settings : GeneralSettings
        @EnvironmentObject var thread : ThreadObj
        @EnvironmentObject var imageDisplayer : ImageDisplayHandler
        @ObservedObject var OPPost : ChanPost
        var theme : ChannerTheme
        var dateStyler : DateFormatter
        
        init(_ OPPost : ChanPost) {
            theme = ColorSettings.current.activeTheme
            
            //date
            dateStyler = DateFormatter()
            dateStyler.dateStyle = .short
            dateStyler.timeStyle = .short
            self.OPPost = OPPost
            OPPost.LoadHDAttachment()
        }
        
        var body : some View {
            //OP number
            VStack(alignment: .leading) {
                //top section where number is
                HStack() {
                    HStack() {
                        //number
                        Text(String(OPPost.rawData.no ?? -1))
                        Divider()
                        //name
                        Text(String(OPPost.rawData.name ?? "no name?"))
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
                
                Spacer(minLength: 15)
                
                if(OPPost.hasAttachment) {
                    //attachment
                    HStack() {
                        if(OPPost.hdAttachmentLoaded) {
                            //max height is 300 points
                            ZStack() {
                                Image(uiImage: OPPost.hdAttachment!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxHeight:300)
                                    .contentShape(Rectangle())
                                    .clipped()
                                    .mask(RoundedRectangle(cornerRadius: 15))
                                //Filename
                                if(settings.showFileName) {
                                    VStack() {
                                        Spacer()
                                        HStack() {
                                            Text(OPPost.GetFileName())
                                                .font(SwiftUI.Font.footnote)
                                                .lineLimit(1)
                                                .padding(10)
                                                .background(RoundedRectangle(cornerRadius: 10)
                                                    .foregroundColor(theme.foreground.opacity(0.7))
                                                    .shadow(radius: 3))
                                            Spacer()
                                        }
                                    }
                                    .padding(7)
                                }
                                
                            }
                            .onTapGesture {
                                imageDisplayer.loadImage(withImage: OPPost.hdAttachment!)
                            }
                        } else {
                            Text("loading attachment...")
                                .frame(height: 300)
                        }
                    }
                    Spacer(minLength: 15)
                }
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
                    
                    //text
                    if(OPPost.rawData.com != nil) {
                        HStack() {
                            OPPost.GetCommentView()
                            Spacer()
                        }
                        Divider()
                    }
                    
                    //details
                    HStack() {
                        //date
                        Text(dateStyler.string(from: OPPost.GetDatePosted()))
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(15)
                .background(RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(theme.foreground))
            }
            .padding(10)
            .background(
                LinearGradient(colors: [theme.accentColor, theme.offColor, theme.accentColor], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .cornerRadius(15))
            .padding([.horizontal], 10)
            .padding([.vertical], 3)
        }
    }
    
    
}

extension ThreadView {
    struct ThreadReply : View {
        @EnvironmentObject var imageDisplayer : ImageDisplayHandler
        @EnvironmentObject var thread : ThreadObj
        @ObservedObject var reply : ChanPost
        var replyData : ChanPostRaw { reply.rawData }
        var theme : ChannerTheme
        var dateStyler : DateFormatter
        @State var path = NavigationPath()
        @State var replyImage : Image?
        
        init(_ reply : ChanPost) {
            theme = ColorSettings.current.activeTheme
            
            //date
            dateStyler = DateFormatter()
            dateStyler.dateStyle = .short
            dateStyler.timeStyle = .short
            self.reply = reply
            reply.LoadTNAttachment()
        }
        
        var body : some View {
            VStack(alignment: .leading) {
                HStack() {
                    Text(String(replyData.no!))
                    Divider()
                    Text(replyData.name!)
                    Divider()
                    PostActionsMenu()
                        .shareComment(is: reply.rawData.com)
                        .shareSubject(is: reply.rawData.sub)
                        .sharePostLink(is: reply.GetPostURL())
                }
                .fixedSize()
                HStack(alignment: .top) {
                    //image
                    if(reply.hasAttachment) {
                        if(reply.tnAttachmentLoaded) {
                            Image(uiImage: reply.tnAttachment!)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .cornerRadius(15)
                                .onTapGesture {
                                    imageDisplayer.loadImage(withData: reply.GetHDImageData()!)
                                }
                                .padding([.trailing], 10)
                        } else {
                            Text("loading...")
                                .mask({
                                    RoundedRectangle(cornerRadius: 15)
                                })
                                .padding([.trailing], 10)
                        }
                        Spacer()
                    }
                    //text
                    reply.GetCommentView()
                        .environmentObject(thread)
                }
                HStack() {
                    Text(dateStyler.string(from: reply.GetDatePosted()))
                    Divider()
                }
            }
            .padding(15)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(theme.foreground)
            )
            .overlay(content: {
                RoundedRectangle(cornerRadius: 15)
                    .strokeBorder(theme.accentColor, lineWidth: 3)
            })
        }
    }    
}
