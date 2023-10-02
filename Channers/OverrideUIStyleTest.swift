//
//  OverrideUIStyleTest.swift
//  Channers
//
//  Created by Rez on 6/1/23.
//

import SwiftUI

struct OverrideUIStyleTest: View {
    @ObservedObject var colorSettings = ColorSettings.current
    var currentScheme : ColorScheme = .light
    var flipScreen : Bool = false
    var colorControl = testUIFlipper()
    
    var body: some View {
        ZStack() {
            Button("Press to flip", action: {
                colorSettings.setNewTheme(as: "4chan")
            })
            .foregroundColor(colorSettings.accent)
            .preferredColorScheme(currentScheme)
            
            if(flipScreen) {
                ZStack() {
                    Color.orange
                        .ignoresSafeArea(.all)
                    Text("Flipping")
                }
            }
            
        }
    }
    
    
}

class testUIFlipper {
    var mode = 0
    
    var testColor : Color {
        switch mode {
        case 0:
            return .green
        case 1:
            return .red
        default:
            return .blue
        }
        
    }
    
    var testColor2 : Color = .green
}

struct OverrideUIStyleTest_Previews: PreviewProvider {
    static var previews: some View {
        OverrideUIStyleTest()
    }
}
