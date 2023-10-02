//
//  ShareButton.swift
//  Channers
//
//  Created by Rez on 7/2/23.
//

import SwiftUI

struct SmallPartsTest: View {
    init() {
        ColorSettings.current.setNewTheme(as: "trans")
    }
    
    var body: some View {
        ChannerView.ShareLabel()
            .environmentObject(ColorSettings.current)
    }
}

struct SmallPartsTest_Preview: PreviewProvider {
    static var previews: some View {
        SmallPartsTest()
    }
}

class ChannerView {
    struct ShareLabel : View {
        @EnvironmentObject var theme : ColorSettings
        
        var body : some View {
            Label("Share", systemImage: "square.and.arrow.up.fill")
                .labelStyle(.iconOnly)
                .foregroundColor(theme.accent)
        }
    }
}
