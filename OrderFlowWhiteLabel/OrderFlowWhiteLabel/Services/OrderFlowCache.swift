//
//  OrderFlowCache.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Eduardo on 25/11/25.
//
import Foundation

enum CacheKeys: String {
    case email
}

actor OrderFlowCache {
    
    static let shared = OrderFlowCache()
    
    var cache: [String: Any] = [:]
    
    private init() { }
    
    func set(_ value: Any, forKey key: CacheKeys) {
        cache[key.rawValue] = value
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    func value(forKey key: CacheKeys) -> Any? {
        if let memoryValue = cache[key.rawValue] {
            return memoryValue
        }
        
        return UserDefaults.standard.value(forKey: key.rawValue)
    }
}

