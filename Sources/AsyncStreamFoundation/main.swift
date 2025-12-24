//
//  main.swift
//  ExperimentsEverything
//
//  Created by Anbalagan on 11/12/24.
//

import Foundation

extension AsyncStream where Element: Equatable & Sendable {
    func distinctUntilChanged() -> AsyncStream<Element> {
        AsyncStream { continuation in
            let sequence = self
            Task { @Sendable in
                var last: Element? = nil
                for await item in sequence {
                    if last != item {
                        last = item
                        continuation.yield(item)
                    }
                }
                
                continuation.finish()
            }
        }
    }
}

extension AsyncStream where Element: Sendable {
    @available(macOS 13.0, *)
    func delay(duration: Duration) -> AsyncStream<Element> {
        AsyncStream { continuation in
            let sequence = self
            let task = Task { @Sendable in
                for await item in sequence {
                    try? await Task.sleep(for: duration)
                    continuation.yield(item)
                }
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}


nonisolated var numbers: AsyncStream<Int> {
    AsyncStream<Int> { continuation in
        continuation.yield(10)
        continuation.yield(10)
        continuation.yield(10)
        continuation.yield(10)
        continuation.yield(10)
        continuation.yield(10)
        continuation.yield(11)
        continuation.yield(10)
        continuation.finish()
    }
}

func test() async {
    for await item in numbers.distinctUntilChanged() {
        print(item)
    }
    
    if #available(macOS 13.0, *) {
        for await item in numbers.delay(duration: .seconds(2)) {
            print(item)
        }
    }
}

await test()
