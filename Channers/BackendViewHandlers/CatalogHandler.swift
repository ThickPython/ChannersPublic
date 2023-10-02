//
//  CatalogHandlers.swift
//  Channers
//
//  Created by Rez on 4/20/23.
//

import Foundation
import SwiftUI

///handles retreiving catalogs for views 
class CatalogHandler : ObservableObject {
    @Published var activeCatalog : CatalogObj?
    static var current = CatalogHandler()
    //catalogs in memory are stored here
    private var storedCatalogs = Cache<String, CatalogObj>()
    
    ///Gets and stores a catalog into the cache
    @available (*, deprecated, message: "use load catalog to get catalog directly")
    func SetCatalog(forBoard : String) {
        if(!storedCatalogs.containsKey(forBoard)) {
            
            print("Getting catalog for board \(forBoard)")
            storedCatalogs[forBoard] = CatalogObj(board: forBoard)
        }
        
        activeCatalog = storedCatalogs[forBoard]!
    }
    
    ///Gets a catalog from the storage, loads the catalog if it doesn't already exist
    func LoadCatalog(forBoard : String) -> CatalogObj {
        if(!storedCatalogs.containsKey(forBoard)) {
            storedCatalogs[forBoard] = CatalogObj(board: forBoard)
        }
        
        return storedCatalogs[forBoard]!
    }

    
    ///fetches the data again for a given catalog
    func RefreshCatalog(forBoard : String) {
        storedCatalogs[forBoard] = CatalogObj(board: forBoard)
    }
    
    ///fetches the data again for the current catalog
    func RefreshCurrent() {
        guard activeCatalog != nil else {
            return
        }
        
        activeCatalog!.GetObj()
    }
}
