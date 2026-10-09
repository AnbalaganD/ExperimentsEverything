//
//  main.swift
//  ExperimentsEverything
//
//  Created by Anbalagan on 07/11/24.
//

import Foundation

var greeting: String = "Hello, Anbalagan D"

let jsonEncoder = JSONEncoder()
let data = try! jsonEncoder.encode(greeting)

// Check if both are equal Directly converting Data and JSONEncoder Data
// Return false because JSONEncoder added extra double quotation both side to String value
print(Data(greeting.utf8) == data)

print(String(data: data, encoding: .utf8)!) // This will add extra double quotation both end
print(greeting)

// Forward slashes (/) in JSON strings are escaped as \/ when encoded
// This is standard JSON escaping behavior for URLs
let sampleURL = "https://www.sample.com/random/test.json"
let sampleData = try! jsonEncoder.encode(sampleURL)
print(String(data: sampleData, encoding: .utf8)!)

// JSONEncoder by default omits the key if the value contains `nil`
let foo = Foo(label: "Dummy", count: nil)
let fooData = try! jsonEncoder.encode(foo)
let fooJson = String(data: fooData, encoding: .utf8)!
print("\n[Default behaviour] Omit Nil value encoding: \n\(fooJson)")

// To preserve nil values to maintain the structure/contract with other services/consumers
// we need to do some extra workaround
let preserveNilfoo = FooPreserveNil(label: "Dummy", count: nil)
let preserveNilfooData = try! jsonEncoder.encode(preserveNilfoo)
let preserveNilfooJson = String(data: preserveNilfooData, encoding: .utf8)!
print("\nPreserve Nil value encoding: \n\(preserveNilfooJson)")
