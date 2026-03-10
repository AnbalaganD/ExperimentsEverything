//
//  Cache.swift
//  ExperimentsEverything
//
//  Created by Anbalagan on 01/02/26.
//

import Foundation

final class CacheExecutor: SerialExecutor {
    let queue = DispatchQueue(label: "com.cache.executor")
    func enqueue(_ job: UnownedJob) {
        queue.async {
            job.runSynchronously(on: self.asUnownedSerialExecutor())
        }
    }
    
    func asUnownedSerialExecutor() -> UnownedSerialExecutor {
        UnownedSerialExecutor(ordinary: self)
    }
}

actor Cache {
    var backstore = [String: String]()
    
    private static let customExecutor = CacheExecutor()
    
    nonisolated var unownedExecutor: UnownedSerialExecutor {
        Cache.customExecutor.asUnownedSerialExecutor()
    }
    
    func getBackStore() -> [String: String] {
        return backstore
    }
}
