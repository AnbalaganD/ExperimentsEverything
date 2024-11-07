//
//  main.swift
//  ExperimentsEverything
//
//  Created by Anbalagan on 07/11/24.
//

let normalBool = true
let optionalBool = Optional<Bool>(true)

print("Bool Size: \(MemoryLayout<Bool>.size)")
print("Optional Bool Size: \(MemoryLayout<Optional<Bool>>.size)", terminator: "\n\n")

print("Bool Stride: \(MemoryLayout<Bool>.stride)")
print("Optional Bool Stride: \(MemoryLayout<Optional<Bool>>.stride)", terminator: "\n\n")

print("Bool Alignment: \(MemoryLayout<Bool>.alignment)")
print("Optional Bool Alignment: \(MemoryLayout<Optional<Bool>>.alignment)")
