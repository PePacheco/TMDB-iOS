//
//  CacheService.swift
//  Api-TMDB
//
//  Created by Pedro Gomes Rubbo Pacheco on 06/07/21.
//

import Foundation

class CacheService {
    
    static let shared: CacheService = CacheService()
    
    let cache: NSCache<NSString, NSArray>
    
    private init() {
        self.cache = NSCache<NSString, NSArray>()
    }
    
    func store(_ movies: [Movie], type: String) {
        let key = "movies\(type)" as NSString
        cache.setObject(movies as NSArray, forKey: key)
    }
    
    func retrieve(type: String) -> [Movie]? {
        let key = "movies\(type)" as NSString
        if let data = cache.object(forKey: key) {
            return data as? [Movie]
        }
        return nil
    }
}
