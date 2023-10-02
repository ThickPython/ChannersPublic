//
//  ChannersApp.swift
//  Channers
//
//  Created by Rez on 4/12/23.
//

import SwiftUI

#if DEBUG

@main
struct ChannersApp: App {
    var body: some Scene {
        WindowGroup {
            MainPage()
        }
    }
}

#else

@main
struct ChannersApp: App {
    var body: some Scene {
        WindowGroup {
            MainPage()
        }
    }
}

#endif
