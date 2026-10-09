//
//  main.swift
//  ExperimentsEverything
//
//  Created by Anbalagan on 11/12/24.
//

import Foundation

/// Creates a derived stream that suppresses adjacent duplicate values.
///
/// Cancellation flow:
/// 1. The consumer task is cancelled (or stops consuming), which terminates the
///    derived stream.
/// 2. `onTermination` cancels the task that is reading the source stream.
/// 3. The task observes cancellation, leaves its loop, and `defer` finishes the
///    continuation. This releases resources held by the derived stream.
///
/// The task created here is unstructured, so it does not automatically inherit
/// cancellation from the consumer. `onTermination` provides that explicit link.
extension AsyncStream where Element: Equatable & Sendable {
    func distinctUntilChanged() -> AsyncStream<Element> {
        let (stream, continuation) = AsyncStream<Element>.makeStream()

        let task = Task {
            defer { continuation.finish() }

            var last: Element?
            for await item in self {
                guard !Task.isCancelled else { return }

                if last != item {
                    last = item
                    continuation.yield(item)
                }
            }
        }

        continuation.onTermination = { _ in
            task.cancel()
        }

        return stream
    }
}

/// Creates a derived stream whose elements are emitted after `duration`.
///
/// `Task.sleep(for:)` throws `CancellationError` when this work task is
/// cancelled. Catching it ends the task cleanly; `defer` still calls `finish()`.
extension AsyncStream where Element: Sendable {
    @available(macOS 13.0, *)
    func delay(duration: Duration) -> AsyncStream<Element> {
        let (stream, continuation) = AsyncStream<Element>.makeStream()

        let task = Task {
            defer { continuation.finish() }

            for await item in self {
                try await Task.sleep(for: duration)
                try Task.checkCancellation()
                continuation.yield(item)
            }
        }

        continuation.onTermination = { _ in
            task.cancel()
        }

        return stream
    }
}

nonisolated var numbers: AsyncStream<Int> {
    AsyncStream<Int> { continuation in
        continuation.yield(10)
        continuation.yield(10)
        continuation.yield(10)
        continuation.yield(10)
        continuation.yield(11)
        continuation.yield(10)
        continuation.yield(10)
        continuation.yield(10)
        continuation.finish()
    }
}

func test() async {
    for await item in numbers.distinctUntilChanged() {
        print("Distinct:", item)
    }

    if #available(macOS 13.0, *) {
        for await item in numbers.delay(duration: .seconds(1)) {
            print("Delay:", item)
        }
    }

    let task = Task {
        print("Start")

        if #available(macOS 13.0, *) {
            for await item in numbers.delay(duration: .seconds(1)) {
                print("Item:", item)
            }
        }
    }

    try? await Task.sleep(nanoseconds: 1_100_000_000)
    print("Initiate cancellation")
    task.cancel()
}

Task { await test() }
dispatchMain()
