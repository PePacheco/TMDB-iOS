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
    
    func store(_ movies: [Movie]) {
        cache.setObject(movies as NSArray, forKey: "movies")
    }
    
    func retrieve() -> [Movie]? {
        if let data = cache.object(forKey: "movies") as? [Movie] {
            return data
        }
        return nil
    }
}
