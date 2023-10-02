//
//  GeneralSettingsView.swift
//  Channers
//
//  Created by Rez on 4/17/23.
//

import SwiftUI



struct GeneralSettingsView: View {
    @EnvironmentObject var theme : ColorSettings
    @State var showingThemeSelector = false
    let genSettings = GeneralSettings.current
    let test = GeneralSettings.current.alphabeticalBoardSort
    
    
    var body: some View {
        NavigationStack() {
            ScrollView() {
                
                Button(action: {
                    showingThemeSelector.toggle()
                }, label: {
                    HStack() {
                        VStack(alignment: .leading) {
                            Text("Theme")
                                .bold()
                                .font(.title3)
                            Text(theme.activeTheme.displayAs)
                        }
                        Text("\"\(theme.activeTheme.description)\"")
                            .italic()
                            .fontWeight(.light)
                            .font(.footnote)
                            .padding([.leading], 5)
                        Spacer()
                        LinearGradient(colors:
                                        [theme.activeTheme.accentColor,
                                         theme.activeTheme.offColor],
                                       startPoint: .topLeading, endPoint: .bottomTrailing)
                        .frame(width: 70, height: 50)
                        .cornerRadius(15)
                    }
                    .foregroundColor(theme.primary)
                    .settingSection()
                })
                .popover(isPresented: $showingThemeSelector, content: {
                    ThemeSelector(showPopup: $showingThemeSelector)
                })
                
                VStack() {
                    HStack() {
                        Text("Default Board Display")
                        Spacer()
                    }
                    Picker("Board view", selection: $boardPostsFormat, content: {
                        Text("Catalog").tag(GeneralSettings.boardPostStyle.catalog)
                        Text("All")
                            .tag(GeneralSettings.boardPostStyle.all)
                        Text("Archive")
                            .tag(GeneralSettings.boardPostStyle.archive)
                    })
                    .pickerStyle(.segmented)
                }
                .settingSection()
                
                VStack() {
                    HStack() {
                        Text("Default Post Preview Style")
                        Spacer()
                    }
                    Picker("Preview style", selection: $postPreviewStyle, content: {
                        Text("Big").tag(GeneralSettings.postPreviewStyle.defaultBig)
                        Text("Compact").tag(GeneralSettings.postPreviewStyle.compact)
                        Text("Image only").tag(GeneralSettings.postPreviewStyle.imageOnly)
                        Text("Text only").tag(GeneralSettings.postPreviewStyle.textOnly)
                    })
                    .pickerStyle(.segmented)
                }
                .settingSection()
                
                VStack() {
                    HStack() {
                        Text("Default comment loading")
                        Spacer()
                    }
                    Picker("Load style", selection: $commentViewStyle, content: {
                        Text("Catalog").tag(GeneralSettings.commentsViewStyle.catalogPreview)
                        Text("All").tag(GeneralSettings.commentsViewStyle.all)
                    })
                    .pickerStyle(.segmented)
                }
                .settingSection()
                
                VStack() {
                    HStack() {
                        Text("Default board")
                        Spacer()
                    }
                    .padding(5)
                    TextField(text: $defaultBoard,
                              prompt: Text("board"))
                    {
                        Text("Default board")
                            .foregroundColor(theme.primary)
                    }
                    .padding(10)
                    .background(.quaternary, in: RoundedRectangle(cornerRadius: 10))
                    
                        
                }
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(theme.foreground))
                
                
                VStack() {
                    /*
                    BoolSwitch(name: "Infinite Scroll", bind: $infiniteScroll)
                    BoolSwitch(name: "Refresh on next page", bind: $refreshNextPage)
                    BoolSwitch(name: "Enable Haptics", bind: $enableHaptics)
                     */
                    BoolSwitch(name: "Show board names", bind: $showBoardNames)
                    BoolSwitch(name: "Alphabetical boards", bind: $alphabeticalBoardSort)
                    BoolSwitch(name: "Show attachment names", bind: $showFileName)
                }
                .padding(15)
                .background(RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(theme.foreground))
            }
            .navigationTitle(
                Text("Settings")
            )
            .navigationBarTitleDisplayMode(.inline)
            .padding([.horizontal], 15)
            .onChange(of: boardPostsFormat, perform: { val in
                genSettings.defaultBoardPosts = val
            })
            .onChange(of: postPreviewStyle, perform: { val in
                genSettings.defaultPostPreview = val
            })
            .onChange(of: commentViewStyle, perform: { val in
                genSettings.defaultCommentsView = val
            })
            .onChange(of: infiniteScroll, perform: { val in
                genSettings.infiniteScrollEnabled = val
            })
            .onChange(of: refreshNextPage, perform: { val in
                genSettings.refreshOnNextPage = val
            })
            .onChange(of: defaultBoard, perform: { val in
                genSettings.defaultBoardToLoad = val
            })
            .onChange(of: enableHaptics, perform: { val in
                genSettings.enableHaptics = val
            })
            .onChange(of: showBoardNames, perform: { val in
                genSettings.showBoardNames = val
            })
            .onChange(of: alphabeticalBoardSort, perform: { val in
                genSettings.alphabeticalBoardSort = val
            })
            .onChange(of: showFileName, perform: { val in
                genSettings.showFileName = val
            })
            .background(theme.background)
        }
    }
    
    //settings
    @State var boardPostsFormat : GeneralSettings.boardPostStyle
    @State var postPreviewStyle : GeneralSettings.postPreviewStyle
    @State var commentViewStyle : GeneralSettings.commentsViewStyle
    @State var infiniteScroll : Bool
    @State var refreshNextPage : Bool
    @State var defaultBoard : String
    @State var enableHaptics : Bool
    @State var showBoardNames : Bool
    @State var alphabeticalBoardSort : Bool
    @State var showFileName : Bool
    
    init() {
        self.boardPostsFormat = genSettings.defaultBoardPosts
        self.postPreviewStyle = genSettings.defaultPostPreview
        self.commentViewStyle = genSettings.defaultCommentsView
        self.infiniteScroll = genSettings.infiniteScrollEnabled
        self.refreshNextPage = genSettings.refreshOnNextPage
        self.defaultBoard = genSettings.defaultBoardToLoad
        self.enableHaptics = genSettings.enableHaptics
        self.showBoardNames = genSettings.showBoardNames
        self.alphabeticalBoardSort = genSettings.alphabeticalBoardSort
        self.showFileName = genSettings.showFileName
    }
    
    struct BoolSwitch : View {
        @EnvironmentObject var colorSettings : ColorSettings
        var name : String
        var subtitle : String
        var bind : Binding<Bool>
        
        init(name: String, subtitle: String = "", bind : Binding<Bool>) {
            self.name = name
            self.subtitle = subtitle
            self.bind = bind
        }
        
        var body : some View {
            HStack() {
                Text(name)
                    .foregroundColor(colorSettings.primary)
                Spacer()
                Toggle(isOn: bind, label: {
                })
                .tint(.accentColor)
            }
        }
    }
}

struct ThemeSelector: View {
    @EnvironmentObject var currentTheme : ColorSettings
    @Binding var showPopup : Bool
    
    var body: some View {
        ScrollView() {
            Button(action: {
                showPopup = false
            }, label: {
                Label("Dismiss", systemImage: "chevron.down.circle.fill")
                    .foregroundColor(.secondary)
                    .font(.title2)
                    .labelStyle(.iconOnly)
                    .padding()
            })
            ThemePreview(showPopup: $showPopup, themeToPreview: DefaultChanner())
            ThemePreview(showPopup: $showPopup, themeToPreview: RedAsBlood())
            ThemePreview(showPopup: $showPopup, themeToPreview: Trans())
            ThemePreview(showPopup: $showPopup, themeToPreview: FourChan())
        }
    }
    
    struct ThemePreview : View {
        @Binding var showPopup : Bool
        var themeToPreview : ChannerTheme
        
        var body: some View {
            Button(action: {
                ColorSettings.current.setNewTheme(as: themeToPreview.themeID)
                showPopup = false
            }, label: {
                VStack(alignment: .leading) {
                    Text(themeToPreview.displayAs)
                        .bold()
                        .font(.title3)
                    Text(themeToPreview.description)
                    LinearGradient(colors: [themeToPreview.accentColor, themeToPreview.offColor], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .frame(height: 60)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }
                .foregroundColor(.primary)
                .padding(10)
                .background(themeToPreview.background.cornerRadius(15))
                .padding([.horizontal], 20)
                .padding([.bottom], 15)
            })
        }
    }
}

struct SettingSection: ViewModifier {
    @EnvironmentObject var theme : ColorSettings
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(RoundedRectangle(cornerRadius: 20)
                .foregroundColor(theme.foreground))
    }
}

extension View {
    func settingSection() -> some View {
        modifier(SettingSection())
    }
}

struct GeneralSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        
        GeneralSettingsView()
            .environmentObject(ColorSettings.current)
    }
}
