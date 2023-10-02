//
//  File.swift
//  Channers
//
//  Created by Rez on 4/24/23.
//

import Foundation
import SwiftUI

///A class that handles image previews
///Should display an active image when image is assigned
///E.X catalog view has an image handler state object, passed to previews, when preview pressed it loads
///an image to the image preview handler
class ImageDisplayHandler : ObservableObject {
    
    ///Should the preview field be up
    ///Image is not necessarily loaded when this is true
    @Published var shouldPreview : Bool
    @Published var activeImage : UIImage?
    
    init() {
        self.shouldPreview = false
    }
    
    ///async loads image from a url, shows
    ///preview pane but does not show an image until it is loaded
    func loadImage(withData: ChanImageData) {
        shouldPreview = true
        FeatureHandlers.GetChanImage(withData, onSucess: {
            img in
            
            DispatchQueue.main.async {
                self.activeImage = img
            }
        }, onFailure: {
            error in
            
            DispatchQueue.main.async {
                self.activeImage = UIImage(named: "imageFail")
            }
        })
    }
    
    ///loads image directly and shows preview pane immediately
    ///image must already be loaded in memory
    func loadImage(withImage : UIImage) {
        shouldPreview = true
        activeImage = withImage
    }
    
    ///Unloads the image from the previewer and removes the activeImage
    ///goes back to the normal view
    func unloadImage() {
        shouldPreview = false
        activeImage = nil
    }
}

///Displays an image when you click on a thumbnail and it gets enlarged
struct ImageDisplayViewer : View {
    @EnvironmentObject var displayHandler : ImageDisplayHandler
    @EnvironmentObject var themeSettings : ColorSettings
    
    var body: some View {
        ZStack() {
            //Image
            VStack() {
                Spacer()
                if(displayHandler.activeImage != nil) {
                    Image(uiImage: displayHandler.activeImage!)
                        .resizable()
                        .scaledToFit()
                } else {
                    Text("Loading...")
                }
                Spacer()
            }
            //Image controls
            VStack() {
                Spacer()
                HStack(spacing: 30) {
                    Spacer()
                    //Image information
                    Label("Info", systemImage: "info")
                        .foregroundColor(themeSettings.accent)
                        .font(.title)
                    //shown and active
                    if(displayHandler.activeImage != nil) {
                        let image = Image(uiImage: displayHandler.activeImage!)
                        ShareLink(item: image,
                                  preview: SharePreview("Image to share", image: image),
                                  label: {
                            Label("Share Image", systemImage: "square.and.arrow.up")
                        })
                        //Download
                        Button(action: {
                            UIImageWriteToSavedPhotosAlbum(displayHandler.activeImage!, nil, nil, nil)
                        }, label: {
                            Label("Download", systemImage: "square.and.arrow.down")
                        })
                    }
                    //share and download grayed out
                    else {
                        Label("Share Image Disabled", systemImage: "square.and.arrow.up")
                            .opacity(0.2)
                        Label("Download", systemImage: "square.and.arrow.down")
                            .opacity(0.2)
                    }
                    
                    //Cancel image display
                    Button(action: {
                        displayHandler.unloadImage()
                    }, label: {
                        Label("Cancel Display", systemImage: "xmark")
                    })
                    Spacer()
                }
                .labelStyle(.iconOnly)
                .foregroundColor(themeSettings.accent)
                .font(.title)
                .border(themeSettings.accent)
                .padding([.bottom], 50)
            }
        }
        .ignoresSafeArea()
        .background(Color.black)
    }
}

///modifier that allows an image clicked to be displayed on top of everything
struct ImageDisplayable : ViewModifier {
    @StateObject var displayHandler = ImageDisplayHandler()
    @EnvironmentObject var themeSettings : ColorSettings
    var barDisplayMode : Visibility {
        displayHandler.shouldPreview ? .hidden : .automatic
    }
    
    func body(content: Content) -> some View {
        ZStack() {
            content
                .environmentObject(displayHandler)
            if(displayHandler.shouldPreview) {
                ImageDisplayViewer()
            }
        }
        .environmentObject(displayHandler)
        .toolbar(barDisplayMode, for: .tabBar)
        .toolbar(barDisplayMode, for: .navigationBar)
    }
}

extension View {
    func imageDisplayable() -> some View {
        modifier(ImageDisplayable())
    }
}

