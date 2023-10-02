//
//  MainPage.swift
//  Channers
//
//  Created by Rez on 4/19/23.
//

import SwiftUI

struct MainPage: View {
    @State var activePage : ActivePage 
    @StateObject var theme : ColorSettings = ColorSettings.current
    @StateObject var genSettings = GeneralSettings.current
    var mainPagePath = NavPathHandler()
    var bookmarksPath = NavPathHandler()
    
    init() {
        activePage = .board
        if(GeneralSettings.current.defaultBoardToLoad != ""
           && AppConsts.allForums.contains(
            GeneralSettings.current.defaultBoardToLoad.lowercased()
           )) {
            mainPagePath.openCatalog(forBoard: GeneralSettings.current.defaultBoardToLoad.lowercased())
        }
    }
    
    var body: some View {
        TabView(selection: $activePage) {
            PageOfBoardsView()
                .tabItem {
                    Label("Boards", systemImage: "square.stack")
                }
                .tag(ActivePage.board)
                .toolbarBackground(theme.background, for: .tabBar)
                .environmentObject(mainPagePath)
            
            BookmarkedThreadsView()
                .tabItem {
                    Label("Bookmarks", systemImage: "book.fill")
                }
                .tag(ActivePage.bookmarks)
                .toolbarBackground(theme.background, for: .tabBar)
                .environmentObject(bookmarksPath)
                
            GeneralSettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(ActivePage.setting)
                .toolbarBackground(theme.background, for: .tabBar)
                .toolbarBackground(theme.background, for: .navigationBar)
        }
        .tint(theme.accent)
        .environmentObject(theme)
        .environmentObject(genSettings)
        .onAppear(perform: {
            let tabBarAppear =  UITabBarAppearance()
            tabBarAppear.configureWithOpaqueBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppear
            
            let navBarAppear = UINavigationBarAppearance()
            navBarAppear.backgroundColor = UIColor(theme.background)
            UINavigationBar.appearance().standardAppearance = navBarAppear
        })
    }
    
}

//active page controlled by the bottom bar
enum ActivePage {
    case board
    case bookmarks
    case setting
}

struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        MainPage()
    }
}
