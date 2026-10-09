import Dispatch

let semaphore = DispatchSemaphore(value: 1)

semaphore.signal()
