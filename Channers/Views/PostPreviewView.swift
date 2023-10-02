//
//  PostPreviewBuilder.swift
//  Channers
//
//  Created by Rez on 4/19/23.
//

import Foundation
import SwiftUI

///Previews a post if the post ISNT a simple thread
struct PostPreview : View {
    @ObservedObject var OPPost : ChanPost
    @EnvironmentObject var theme : ColorSettings
    @EnvironmentObject var pathHandler : NavPathHandler
    @EnvironmentObject var imageDisplayer : ImageDisplayHandler
    @EnvironmentObject var settings : GeneralSettings
    @State var previewImage : Image?
    var dateStyler : DateFormatter
    var previewStyle : GeneralSettings.postPreviewStyle
    
    init(OPPost: ChanPost, previewStyle : GeneralSettings.postPreviewStyle) {
        self.OPPost = OPPost
        self.previewStyle = previewStyle
        //date
        dateStyler = DateFormatter()
        dateStyler.dateStyle = .short
        dateStyler.timeStyle = .short
    }
    
    var body : some View {
        switch previewStyle {
        case .defaultBig:
            BuildBig()
        case .compact:
            BuildCompact()
        case .imageOnly:
            BuildImageOnly()
        case .textOnly:
            BuildCompact()
        }
    }
    
    @ViewBuilder func BuildBig() -> some View {
        VStack() {
            bigHeaderBuilder()
            bigAttachmentBuilder()
                .onAppear {
                    OPPost.LoadHDAttachment()
                }
                .onTapGesture {
                    imageDisplayer.loadImage(withData: OPPost.GetHDImageData()!)
                }
            bigContentBuilder()
                .onTapGesture {
                    pathHandler.openThread(fromBoard: OPPost.board, withID: OPPost.rawData.no!)                }
        }
        .postPreviewModifier(withTheme: theme.activeTheme)
    }
    
    @ViewBuilder func BuildCompact() -> some View {
        Button(action: {
            pathHandler.openThread(fromBoard: OPPost.board, withID: OPPost.rawData.no!)
        }, label: {
            VStack() {
                //name and ID
                CompactNameID()
                    .fixedSize(horizontal: false, vertical: true)
                Divider()
                //attachment and else
                HStack() {
                    CompactAttachment()
                        .onAppear {
                            OPPost.LoadTNAttachment()
                        }
                        .onTapGesture {
                            imageDisplayer.loadImage(withData: OPPost.GetHDImageData()!)
                        }
                    Spacer(minLength: 15)
                    VStack() {
                        CompactContent()
                        Spacer()
                        CompactDetails()
                    }
                }
            }
            .padding(15)
            .background(theme.foreground.cornerRadius(15))
        })
    }
    
    @ViewBuilder func BuildImageOnly() -> some View {
        VStack() {
            CompactNameID()
            bigAttachmentBuilder()
                .onAppear {
                    OPPost.LoadHDAttachment()
                }
            CompactDetails()
        }
        .postPreviewModifier(withTheme: theme.activeTheme)
    }
}
