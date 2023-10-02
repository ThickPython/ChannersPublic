//
//  DefaultsManager.swift
//  Channers
//
//  Created by Rez on 4/17/23.
//

import Foundation

///Provides some nice functions for defaults like setting default values
class DefaultsHelper {
    
    ///Gets the setting, sets the default value if it doesn't exist
    static func getSetting<T>(forKey : String, defaultValue : T) -> T {
        if(UserDefaults.standard.object(forKey: forKey) == nil) {
            UserDefaults.standard.setValue(defaultValue, forKey: forKey)
        }
        
        return UserDefaults.standard.object(forKey: forKey) as! T
    }
}
