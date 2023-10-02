//
//  BoardContentView.swift
//  Channers
//
//  Created by Rez on 5/25/23.
//
//  Views the content for a board offering 3 options

import SwiftUI

///a 3 choice view for a board
struct BoardContentView: View {
    var board : String
    @EnvironmentObject var theme : ColorSettings
    @EnvironmentObject var path : NavPathHandler
    @State var pagesToLoad : Int = 1
    
    @ObservedObject var catalog : CatalogObj
    @ObservedObject var threadList : ThreadListObj
    //@ObservedObject var recentPosts : RRecentPostsObj
    
    @State var displayMode : ActiveDisplay = .catalog
    
    var dateFormatter : DateFormatter
    var intervalFormatter : DateComponentsFormatter
    
    init(board : String = "fallback") {
        self.board = board
        catalog = CatalogHandler.current.LoadCatalog(forBoard: board)
        threadList = ThreadListHandler.current.LoadList(forBoard: board)
        
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        intervalFormatter = DateComponentsFormatter()
        intervalFormatter.allowedUnits = [.day, .hour, .minute, .second]
        intervalFormatter.unitsStyle = .abbreviated
    }
    
    var body: some View {
        ScrollView() {
            Picker("Display mode", selection: $displayMode, content: {
                Text("Catalog").tag(ActiveDisplay.catalog)
                Text("Thread List").tag(ActiveDisplay.threadList)
            })
            .zIndex(99)
            .frame(height: 50)
            .pickerStyle(.segmented)
            
            //Display content here
            if(displayMode == .catalog) {
                catalogContent()
            } else if(displayMode == .threadList) {
                threadlistContent()
            } else {
                Text("add recent post support silly")
            }
        }
        .padding([.horizontal], 10)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("/\(catalog.board)/")
        .refreshable {
            CatalogHandler.current.RefreshCurrent()
        }
        .background(theme.background)
    }
    
    
    enum ActiveDisplay {
        case catalog
        case threadList
        case recentPosts
    }
    
    @ViewBuilder private func catalogContent() -> some View {
        if(catalog.canDisplay) {
            ForEach(0..<pagesToLoad, id: \.self) { index in
                ForEach(catalog.data?.pages[index].threads ?? []) {
                    thread in
                    PostPreview(OPPost: thread, previewStyle: GeneralSettings.current.defaultPostPreview)
                }
            }
            if(catalog.data?.pages.count ?? 0 > pagesToLoad) {
                Button(action: {
                    pagesToLoad += 1
                }, label: {
                    Text("Load more :3")
                        .frame(width: 300, height: 50)
                        .foregroundColor(theme.primary)
                        .background(RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(theme.accent))
                })
            } else {
                Text("No more replies :(")
            }
        } else {
            ProgressView()
                .progressViewStyle(.circular)
            Text("Loading catalog for /\(catalog.board)/")
        }
    }
    
    @ViewBuilder private func threadlistContent() -> some View {
        if(threadList.canDisplay) {
            LazyVGrid(columns: [GridItem(.flexible()),
                                GridItem(.flexible())],
                      content: {
                ForEach((0..<(threadList.threads?.pages.count ?? 0)), id: \.self) { num in
                    ForEach((threadList.threads?.pages[num].threads)!) { thread in
                        SimpleThreadPreview(thread)
                    }
                }
            })
        }
    }
    
    @ViewBuilder private func recentPostsContent() -> some View {
        
    }
    
    @ViewBuilder func SimpleThreadPreview(_ thread : ChanThreadSimple) -> some View {
        VStack() {
            HStack() {
                Text(String(thread.no))
                Spacer()
            }
            
            HStack() {
                Label("\(thread.replies)", systemImage: "message")
                    .labelStyle(.titleAndIcon)
                Spacer()
                Divider()
                Spacer()
                Text("\(intervalFormatter.string(from: thread.lastModifiedDate, to: Date.now) ?? "?")")
            }
            .foregroundColor(theme.primary)
            
        }
        .padding([.horizontal], 20)
        .padding([.vertical], 10)
        .background(RoundedRectangle(cornerRadius: 15)
            .foregroundColor(theme.foreground))
        .onTapGesture {
            path.openThread(fromBoard: board, withID: thread.no)
        }
    }
}

struct BoardContentView_Previews: PreviewProvider {
    static var previews: some View {
        BoardContentDebugPreview()
            .environmentObject(NavPathHandler())
            .environmentObject(ColorSettings.current)
        
    }
    
    struct BoardContentDebugPreview: View {
        @EnvironmentObject var path : NavPathHandler
        
        init() {
            GeneralSettings.current.defaultPostPreview = .defaultBig
            ColorSettings.current.setNewTheme(as: "4chan")
        }
        
        var body: some View {
            TabView() {
                NavigationStack(path: $path.path, root: {
                    BoardContentView(board: "lgbt")
                        .navigationDestination(for: Threadloader.self, destination: {
                            loader in
                            
                            ThreadView(board: loader.board, id: loader.postID)
                        })
                        .imageDisplayable()
                })
            }
        }
    }
}


