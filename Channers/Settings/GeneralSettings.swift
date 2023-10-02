//
//  GeneralSettings.swift
//  Channers
//
//  Created by Rez on 4/17/23.
//

import Foundation

///Contains settings for all the general related settings, static keys, and vars for accessing and setting
///DO NOT INSTANTIATE JUST USE THE CURRENT
class GeneralSettings : ObservableObject {
    static let current : GeneralSettings = GeneralSettings()
    let defaults = UserDefaults.standard
    
    private static let defaultBoardPostsFormatKey = "boardPostViewFormat"
    private static let defaultPostsPreviewFormatKey = "boardPostsPreviewFormat"
    private static let defaultCommentsViewKey = "commentsViewFirst"
    
    private static let infiniteScrollingKey = "infiniteScroll"
    private static let refreshOnNextPageKey = "nextPageRefresh"
    private static let defaultBoardToLoad = "defaultBoard"
    private static let enableHapticsKey = "enableHaptics"
    
    //boards page
    private static let showBoardNamesKey = "showBoardNames"
    private static let alphabeticalBoardSortKey = "alphabeticalBoardSort"
    
    //post preview
    private static let showFileNameKey = "showFileName"
    
    //sussy things
    private static let enableNSFWBoardsKey = "enableNSFWKey"
    
    //book marked
    private static let bookmarkedThreadsKey = "bookmarkedThreadsKey"
    
    ///Changes between show all board posts or show the catalog
    var defaultBoardPosts : boardPostStyle {
        didSet {
            defaults.setValue(defaultBoardPosts.rawValue, forKey: GeneralSettings.defaultBoardPostsFormatKey)
        }
    }
    
    ///Sets how previews for posts are formatted on the scrolling screenneee
    var defaultPostPreview : postPreviewStyle {
        didSet {
            defaults.setValue(defaultPostPreview.rawValue, forKey: GeneralSettings.defaultPostsPreviewFormatKey)
        }
    }
    
    ///Which type of comments are displayed first, the catalog preview comments
    ///Or all of them
    var defaultCommentsView : commentsViewStyle {
        didSet {
            defaults.setValue(defaultCommentsView.rawValue, forKey: GeneralSettings.defaultCommentsViewKey)
        }
    }
    
    ///Do you infinitely scroll comments and posts on a board?
    var infiniteScrollEnabled : Bool {
        didSet {
            defaults.setValue(infiniteScrollEnabled, forKey: GeneralSettings.infiniteScrollingKey)
        }
    }
    
    ///When you go to the next page, does it also refresh the data or keep what is cached?
    var refreshOnNextPage : Bool {
        didSet {
            defaults.setValue(refreshOnNextPage, forKey: GeneralSettings.refreshOnNextPageKey)
        }
    }
    
    ///Default board to load, if empty or invalid, it loads all boards
    var defaultBoardToLoad : String {
        didSet {
            defaults.setValue(defaultBoardToLoad, forKey: GeneralSettings.defaultBoardToLoad)
        }
    }
    
    var enableHaptics : Bool {
        didSet {
            defaults.setValue(enableHaptics, forKey: GeneralSettings.enableHapticsKey)
        }
    }
    
    var showBoardNames : Bool {
        didSet {
            defaults.setValue(showBoardNames, forKey: GeneralSettings.showBoardNamesKey)
        }
    }
    
    var alphabeticalBoardSort : Bool {
        didSet {
            defaults.setValue(showBoardNames, forKey: GeneralSettings.alphabeticalBoardSortKey)
        }
    }
    
    var showFileName : Bool {
        didSet {
            defaults.setValue(showFileName, forKey: GeneralSettings.showFileNameKey)
        }
    }
    
    var enableNSFW : Bool {
        didSet {
            defaults.setValue(enableNSFW, forKey: GeneralSettings.enableNSFWBoardsKey)
        }
    }
    
    var bookmarkedThreads : [String] {
        didSet {
            defaults.setValue(bookmarkedThreads, forKey: GeneralSettings.bookmarkedThreadsKey)
        }
    }
    
    init() {
        defaultBoardPosts = boardPostStyle(rawValue: defaults.string(forKey: GeneralSettings.defaultBoardPostsFormatKey) ?? "catalog")!
        defaultPostPreview = postPreviewStyle(rawValue: defaults.string(forKey: GeneralSettings.defaultPostsPreviewFormatKey) ?? "defaultBig")!
        defaultCommentsView = commentsViewStyle(rawValue: defaults.string(forKey: GeneralSettings.defaultCommentsViewKey) ?? "catalogPreview")!
        
        infiniteScrollEnabled = defaults.bool(forKey: GeneralSettings.infiniteScrollingKey)
        refreshOnNextPage = defaults.bool(forKey: GeneralSettings.refreshOnNextPageKey)
        defaultBoardToLoad = defaults.string(forKey: GeneralSettings.defaultBoardToLoad) ?? ""
        enableHaptics = DefaultsHelper.getSetting(
            forKey: GeneralSettings.enableHapticsKey, defaultValue: true)
        showBoardNames = DefaultsHelper.getSetting(
            forKey: GeneralSettings.showBoardNamesKey, defaultValue: false)
        alphabeticalBoardSort = DefaultsHelper.getSetting(
            forKey: GeneralSettings.alphabeticalBoardSortKey, defaultValue: true)
        showFileName = DefaultsHelper.getSetting(
            forKey: GeneralSettings.showFileNameKey, defaultValue: true)
        enableNSFW = DefaultsHelper.getSetting(
            forKey: GeneralSettings.enableNSFWBoardsKey, defaultValue: true)
        
        bookmarkedThreads = defaults.stringArray(forKey: GeneralSettings.bookmarkedThreadsKey) ?? []
    }
    
    enum boardPostStyle : String, CaseIterable {
        case catalog
        case all
        case archive
    }
    
    enum postPreviewStyle : String {
        case defaultBig
        case compact
        case imageOnly
        case textOnly
    }
    
    enum commentsViewStyle : String {
        case catalogPreview
        case all
    }
    
}


