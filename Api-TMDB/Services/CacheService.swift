//
//  CacheService.swift
//  Api-TMDB
//
//  Created by Pedro Gomes Rubbo Pacheco on 06/07/21.
//

import UIKit

class CacheService {
    
    static let shared: CacheService = CacheService()
    
    let cache: NSCache<NSString, UIImage>
    
    private init() {
        self.cache = NSCache<NSString, UIImage>()
    }
    
    func store(key: String, value: UIImage) {
        cache.setObject(value, forKey: key as NSString)
    }
    
    func retrieve(key: String) -> UIImage? {
        if let data = cache.object(forKey: key as NSString) {
            return data
        }
        return nil
    }
}
