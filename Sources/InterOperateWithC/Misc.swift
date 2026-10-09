//
//  Misc.swift
//  ExperimentsEverything
//
//  Created by Anbalagan on 02/09/26.
//

import core

@inline(__always)
func swiftAssert(
    _ condition: Bool,
    message: AssertMessageProvider
) {
    coreAssert(condition, message: message)
}

@inline(__always)
func swiftAssert(
    _ condition: Bool,
    message: @autoclosure () -> String
) {
    if condition {
        let mgs = message()
//        coreAssert(condition, message: { mgs })
    }
}

func printSomething() {
    swiftAssert(2 + 2 == 5, message: { nil })
    swiftAssert(2 + 2 == 4, message: { nil })
}
