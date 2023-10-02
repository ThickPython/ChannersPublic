//
//  CatalogPageTest.swift
//  Channers
//
//  Created by Rez on 4/12/23.
//

import SwiftUI
import HTMLString

struct CatalogPageTest: View {
    @EnvironmentObject var theme : ColorSettings
    @EnvironmentObject var path : NavPathHandler
    @State var pagesToLoad : Int = 1
    @ObservedObject var catalog : CatalogObj
    @State var refreshed = false
    
    init(board : String = "defaultBoard") {
        catalog = CatalogHandler.current.LoadCatalog(forBoard: board)
    }
    
    var body: some View {
        ScrollView() {
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
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("/\(catalog.board)/")
        .refreshable {
            CatalogHandler.current.RefreshCurrent()
        }
        .background(theme.background)
    }
}

struct CatalogPageTest_Previews: PreviewProvider {
    static var previews: some View {
        CatalogPageDebug()
    }
}

struct CatalogPageDebug : View {
    init() {
        GeneralSettings.current.defaultPostPreview = .defaultBig
    }
    
    var body : some View {
        CatalogPageTest(board: "cm")
            .environmentObject(ColorSettings.current)
    }
}
