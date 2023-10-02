//
//  PageofBoards.swift
//  Channers
//
//  Created by Rez on 4/18/23.
//

import SwiftUI

struct PageOfBoardsView : View {
    @ObservedObject var board : BoardsObj
    @EnvironmentObject var theme : ColorSettings
    @EnvironmentObject var pathHandler : NavPathHandler
    @State var showNames : Bool = GeneralSettings.current.showBoardNames
    @State var alphabeticalSort : Bool = GeneralSettings.current.alphabeticalBoardSort
    var boardHandler = BoardsHandler.current
    
    
    var tripleGrid = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
        ]
    
    var singleGrid = [GridItem(.flexible())]
        
    
    init() {
        boardHandler.LoadBoards()
        board = BoardsHandler.current.allBoards!
    }
    
    var body: some View {
        NavigationStack(path: $pathHandler.path) {
            ScrollView() {
                //Board options
                HStack() {
                    //Sort order
                    Toggle("Alphabetical", isOn: $alphabeticalSort)
                        .onChange(of: alphabeticalSort) {
                            newSet in
                            
                            GeneralSettings.current.alphabeticalBoardSort = newSet
                        }
                    Divider()
                    //Set the general setting when this is toggled
                    Toggle("Show names", isOn: $showNames)
                        .onChange(of: showNames) {
                            newSet in
                            
                            GeneralSettings.current.showBoardNames = newSet
                        }
                }
                .padding([.horizontal], 30)
                .onAppear() {
                    refreshSetting()
                }
                Divider()
                Spacer(minLength: 30)
                
                //boards
                if(board.canDisplay) {
                    BuildBoardIcons()
                } else {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
                
            }
            .background(theme.background)
            .navigationTitle("Boards")
            .navigationDestination(for: Threadloader.self, destination: {
                loader in
                
                ThreadView(board: loader.board, id: loader.postID)
            })
            .navigationDestination(for: BoardLoader.self, destination: {
                loader in
                
                BoardContentView(board: loader.board)
            })
        }
        .imageDisplayable()
    }
    
    func refreshSetting() {
        showNames = GeneralSettings.current.showBoardNames
        alphabeticalSort = GeneralSettings.current.alphabeticalBoardSort
    }
}

struct boardPreview : View {
    @EnvironmentObject var theme : ColorSettings
    var board : ChanBoard
    var showName : Bool
    
    
    
    init(board: ChanBoard, showName : Bool) {
        self.board = board
        self.showName = showName
    }
    var body : some View {
        if(showName) {
            ZStack() {
                RoundedRectangle(cornerRadius: 15)
                    .shadow(radius: 1)
                    .foregroundColor(theme.foreground)
                Text("/\(board.rawData.board)/ - \(board.rawData.title)")
                    .foregroundColor(theme.primary)
                    .fontWeight(.semibold)
                
            }
            .frame(height: 50)
            .padding([.horizontal], 15)
        } else {
            ZStack() {
                RoundedRectangle(cornerRadius: 15)
                    .shadow(radius: 1)
                    .foregroundColor(theme.foreground)
                Text("/\(board.rawData.board)/")
                    .foregroundColor(theme.primary)
                    .fontWeight(.semibold)
            }
            .frame(height: 50)
        }
    }
}

struct PageofBoards_Previews: PreviewProvider {
    static var previews: some View {
        BoardPageDebug()
    }
}

struct BoardPageDebug : View {
    var body : some View {
        TabView() {
            PageOfBoardsView()
                .environmentObject(NavPathHandler())
                .environmentObject(ColorSettings.current)
        }
        
    }
}
