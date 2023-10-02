//
//  NavPathTest.swift
//  Channers
//
//  Created by Rez on 4/19/23.
//

import SwiftUI

struct NavPathTest: View {
    
    let text1 = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin imperdiet ipsum purus, sit amet mollis nunc "
    let text2 = "bibendum eget."
    let text3 = " Nulla suscipit mauris non diam varius sagittis. Ut feugiat imperdiet bibendum. Vestibulum dui quam, bibendum sit amet imperdiet sit amet, dapibus sit amet mauris."
    
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Text(text1) +
                Text("[\(text2)](myappurl://action)").bold() +
                Text(text3)+Text("\n\n\n")+Text("bruh")
            }
            .padding()
            .onTapGesture { url in
                print("bruh")
                path.append("hi")
                path.append("bruh")
            }
            .navigationTitle("Main")
            .navigationDestination(for: Int.self) { value in
                Text(value, format: .number)
            }
        }
    }
}

struct NavPathTest_Previews: PreviewProvider {
    static var previews: some View {
        NavPathTest()
    }
}
