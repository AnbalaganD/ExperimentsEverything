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
