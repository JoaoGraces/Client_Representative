//
//  OrderFlowCache.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Eduardo on 25/11/25.
//

enum CacheKeys: String {
    case email
}

actor OrderFlowCache {
    
    static var shared = OrderFlowCache()
    
    var cache: [String: Any] = [:]
    
    private init() { }
    
    func set(_ value: Any, forKey key: CacheKeys) {
        cache[key.rawValue] = value
    }
    
    func value(forKey key: CacheKeys) -> Any? {
        return cache[key.rawValue]
    }
}
