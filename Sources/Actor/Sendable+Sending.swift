//
//  Sendable+Sending.swift
//  ExperimentsEverything
//
//  Created by Anbalagan on 01/02/26.
//

/**
 `Sendable` is a protocol in Swift used to indicate that a type can be safely used across concurrency domains, such as different threads or tasks, without causing data races.

 Non-Sendable classes (reference types without proper synchronization) are restricted in `@Sendable` closures because accessing them concurrently can lead to unsafe behavior.

 Swift 5 vs Swift 6: Task initializer signatures and usage

 Swift 5 mode (implicit `@Sendable` closure; non-Sendable captures are diagnosed):
 ```swift
 // Signature (conceptual)
 public struct Task<Success, Failure: Error> {
     public init(priority: TaskPriority? = nil, operation: @escaping () async -> Success)
 }
 
 // Usage — capturing a non-Sendable is an error in strict mode
 let ref = NonSendableClass()
 Task {
     // Error in strict concurrency: capture of non-Sendable in a @Sendable context
     ref.count += 1
 }
 ```
 Swift 6 mode (closure uses `sending` parameter to accept non-Sendable values safely):
 ```swift
 // Signature (conceptual) — note the `sending` parameter modifier
 public struct Task<Success, Failure: Error> {
     public init(
         priority: TaskPriority? = nil,
         operation: sending @escaping @isolated(any) () async -> Success
     )
 }
 
 // Usage — the closure captures a non-Sendable value which is "sent" into the task
 let ref = NonSendableClass()
 Task {
     // Safe: `ref` is moved/sent into this closure via the `sending` parameter
     ref.count += 1
 }
 // print(ref.count) // Error: 'ref' used after being passed as a 'sending' parameter
 ```
*/
class NonSendableClass {
    var count = 0
}

func exampleFunc() async {
  let nonSendableClass = NonSendableClass()

  // Swift 5 mode this is not allowed but swift 6 mode this allowed because of sending keyword
  Task {
    nonSendableClass.count += 1
  }

  // Access can happen concurrently
  // print(nonSendableClass.count) // this is error at swift 6 mode also 
}
