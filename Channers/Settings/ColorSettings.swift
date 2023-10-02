//
//  ColorSettings.swift
//  Channers
//
//  Created by Rez on 4/18/23.
//

import Foundation
import SwiftUI

///Singleton that handles theme colors in the app
class ColorSettings : ObservableObject {
    static let current = ColorSettings()
    
    ///Active theme, set this to change the theme
    @Published private(set) var activeTheme : ChannerTheme {
        didSet {
            UserDefaults.standard.set(activeTheme.themeID, forKey: ColorSettings.ThemeKey)
        }
    }
    
    var accent : Color { get { activeTheme.accentColor } }
    var offColor : Color { get { activeTheme.offColor } }
    var foreground : Color { get { activeTheme.foreground } }
    var background : Color { get { activeTheme.background } }
    var primary : Color { get { activeTheme.primary } }
    var secondary : Color { get { activeTheme.secondary } }
    
    ///Gets current theme, default is channerscolors
    init() {
        let themeID = DefaultsHelper.getSetting(forKey: ColorSettings.ThemeKey, defaultValue: "channersTheme")
        
        activeTheme = FourChan()
        setNewTheme(as: themeID)
    }
    
    ///Sets the new theme
    func setNewTheme(as themeToSet : String) {
        switch themeToSet {
        case "channersTheme":
            activeTheme = DefaultChanner()
        case "redAsBlood":
            activeTheme = RedAsBlood()
        case "trans":
            activeTheme = Trans()
        case "4chan":
            activeTheme = FourChan()
        default:
            activeTheme = DefaultChanner()
        }
    }
    
    //global theme key
    private static let ThemeKey = "ActiveAppTheme"
}


struct ColorPrimary: ViewModifier {
    @EnvironmentObject var currentTheme : ColorSettings
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(currentTheme.activeTheme.primary)
    }
}

struct ColorSecondary: ViewModifier {
    @EnvironmentObject var currentTheme : ColorSettings
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(currentTheme.activeTheme.secondary)
    }
}

struct ColorAccent: ViewModifier {
    @EnvironmentObject var currentTheme : ColorSettings
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(currentTheme.activeTheme.accentColor)
    }
}

struct ColorOff: ViewModifier {
    @EnvironmentObject var currentTheme : ColorSettings
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(currentTheme.activeTheme.offColor)
    }
}

struct ColorForeground: ViewModifier {
    @EnvironmentObject var currentTheme : ColorSettings
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(currentTheme.activeTheme.foreground)
    }
}

struct ColorBackground: ViewModifier {
    @EnvironmentObject var currentTheme : ColorSettings
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(currentTheme.activeTheme.background)
    }
}



extension View {
    func fgPrimary() -> some View {
        modifier(ColorPrimary())
    }
    
    func fgSecondary() -> some View {
        modifier(ColorSecondary())
    }
    
    func fgAccent() -> some View {
        modifier(ColorAccent())
    }
    
    func fgOffColor() -> some View {
        modifier(ColorOff())
    }
    
    func fgForeground() -> some View {
        modifier(ColorForeground())
    }
    
    func fgBackground() -> some View {
        modifier(ColorBackground())
    }
    
}

struct DefaultChanner : ChannerTheme {
    var themeID = "channersTheme"
    var displayAs = "Channers"
    var description = "Vanilla! If it was green"
    var accentColor: Color = Color("ChannersGreen")
    var offColor: Color = Color("ChannersOffBlue")
    var background: Color = Color(UIColor.systemGray6)
    var foreground: Color = Color("DefaultWB")
    var primary: Color = .primary
    var secondary: Color = .secondary
}

struct RedAsBlood : ChannerTheme {
    var themeID = "redAsBlood"
    var displayAs = "Blood Red"
    var description = "For those who revel in pain... or just don't like blue light"
    var accentColor = Color("BloodRed")
    var offColor: Color = Color("BloodOrange")
    var background: Color = Color(UIColor.systemGray6)
    var foreground: Color = Color("DefaultWB")
    var primary: Color = .primary
    var secondary: Color = .secondary
}

struct Trans : ChannerTheme {
    var themeID = "trans"
    var displayAs = ":3"
    var description = "You know"
    var accentColor = Color("TransBlue")
    var offColor = Color("TransPink")
    var background = Color("TransBG")
    var foreground =  Color("TransFG")
    var primary: Color = .primary
    var secondary: Color = .secondary
}

struct FourChan : ChannerTheme {
    var themeID = "4chan"
    var displayAs = "4Chan"
    var description = "Just like home...?"
    var accentColor : Color = Color("4ChanAccent")
    var offColor: Color = Color("4ChanOff")
    var background = Color("4ChanBG")
    var foreground = Color("4ChanFG")
    var primary: Color = Color("4ChanPrimary")
    var secondary: Color = Color("4ChanSecondary")
    
}

protocol ChannerTheme {
    var themeID : String { get }
    var displayAs : String { get }
    var description : String { get }
    var accentColor : Color { get }
    var offColor : Color { get }
    var secondary : Color { get }
    var background : Color { get }
    var foreground : Color { get }
    var primary : Color { get }
}

