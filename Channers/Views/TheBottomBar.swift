//
//  TheBottomBar.swift
//  Channers
//
//  Created by Rez on 4/19/23.
//

import SwiftUI

struct TheBottomBar: View {
    @Binding var currentPage : ActivePage
    
    var body: some View {
        //The bottom bar
        VStack() {
            Spacer()
            ZStack() {
                RoundedRectangle(cornerRadius: 30)
                    .foregroundColor(.gray)
                HStack() {
                    Spacer()
                    Label("Board", systemImage: "house")
                        .labelStyle(.iconOnly)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .onTapGesture {
                            currentPage = ActivePage.board
                        }
                    Spacer()
                    
                    Label("Settings", systemImage: "gear.circle")
                        .labelStyle(.iconOnly)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .onTapGesture {
                            currentPage = ActivePage.setting
                        }
                    Spacer()
                }
            }
            .frame(height: 50)
            .padding([.horizontal], 25)
            .padding([.bottom], 15)
                
        }
        .ignoresSafeArea()
        .gesture(DragGesture(minimumDistance: 5, coordinateSpace: .global)
            .onChanged({ _ in
                print("dragging")
            }))
    }
}

struct TheBottomBar_Previews: PreviewProvider {
    static var previews: some View {
        Text("plcaeholder")
    }
}
