//
//  File.swift
//  Channers
//
//  Created by Rez on 5/1/23.
//

import Foundation
import SwiftUI

extension PageOfBoardsView {
    @ViewBuilder func BuildBoardIcons() -> some View {
        LazyVGrid(columns: (showNames) ? singleGrid : tripleGrid)
        {
            ForEach((board.data?.GetBoards(alphabetical: alphabeticalSort, nsfw: GeneralSettings.current.enableNSFW))!)
            {
                board in
                
                Button(action: {
                    pathHandler.openCatalog(forBoard: board.rawData.board)
                }, label: {
                    boardPreview(board: board, showName: showNames)
                })
            }
        }
        .padding([.horizontal], 20)
    }
}
