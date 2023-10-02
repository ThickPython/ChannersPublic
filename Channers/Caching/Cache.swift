//
//  Cache.swift
//  Channers
//
//  Created by Rez on 5/19/23.
//

import Foundation

final class Cache<Key: Hashable, Value> {
    private let wrapped = NSCache<KeyCache, Entry>()
    
    ///Inserts an entry with a given key and value, overwrites if already exists
    func insertEntry(_ key : Key, withValue : Value) {
        wrapped.setObject(Entry(withValue), forKey: KeyCache(key))
    }
    
    ///Removes an entry with a given key and value
    func removeEntry(_ key : Key) {
        wrapped.removeObject(forKey: KeyCache(key))
    }
    
    ///Returns an entry from the cache, null if non existent
    func getEntry(_ key: Key) -> Value? {
        return wrapped.object(forKey: KeyCache(key))?.value
    }
    
    ///Returns whether a key exists in the cache
    func containsKey(_ key: Key) -> Bool {
        return wrapped.object(forKey: KeyCache(key)) != nil
    }
    
    subscript(key : Key) -> Value? {
        get { return getEntry(key) }
        set {
            guard let value = newValue else {
                removeEntry(key)
                return
            }
            
            insertEntry(key, withValue: value)
        }
    }
}

//Key extension
extension Cache {
    final class KeyCache: NSObject {
        let key : Key
        
        init(_ key: Key) {
            self.key = key
        }
        
        override var hash: Int { key.hashValue }
        
        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? KeyCache else {
                return false
            }
            
            return value.key == key
        }
    }
}

//Entry extension
extension Cache {
    final class Entry {
        let value : Value
        
        init(_ value: Value) {
            self.value = value
        }
    }
}
