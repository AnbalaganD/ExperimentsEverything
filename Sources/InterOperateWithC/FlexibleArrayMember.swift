//
//  FlexibleArrayMember.swift
//  ExperimentsEverything
//
//  Created by Anbalagan on 02/12/25.
//

import core

struct SwiftIntArray {
    private var ptr: UnsafeMutableRawPointer?
    private var capacity: Int = 0

    private let headerSize = MemoryLayout<IntArray>.size
    private let elementSize = MemoryLayout<CInt>.size

    var count: Int {
        guard let ptr else { return 0 }
        return Int(ptr.load(as: IntArray.self).count)
    }

    init() {}

    mutating func append(_ value: Int) {
        if count == capacity {
            resize()
        }

        // pointer to C IntArray struct
        let headerPtr = ptr!.assumingMemoryBound(to: IntArray.self)

        // write value into values[] flexible array
        let index = count
        let valuePtr = ptr!.advanced(by: headerSize + index * elementSize)
        valuePtr.storeBytes(of: CInt(value), as: CInt.self)

        // update count
        headerPtr.pointee.count = CInt(index + 1)
    }

    func get(_ index: Int) -> Int? {
        guard let ptr else { return nil }
        guard index >= 0, index < count else { return nil }

        let valuePtr = ptr.advanced(by: headerSize + index * elementSize)
        let v = valuePtr.load(as: CInt.self)
        return Int(v)
    }

    private mutating func resize() {
        let newCap = max(1, capacity * 2)
        let totalSize = headerSize + newCap * elementSize

        let newPtr = UnsafeMutableRawPointer.allocate(
            byteCount: totalSize,
            alignment: MemoryLayout<IntArray>.alignment
        )

        newPtr.initializeMemory(as: UInt8.self, repeating: 0, count: totalSize)

        if let oldPtr = ptr {
            // copy old header + values
            let oldSize = headerSize + capacity * elementSize
            newPtr.copyMemory(from: oldPtr, byteCount: oldSize)
            oldPtr.deallocate()
        } else {
            // initialize header
            var value = IntArray()
            value.count = 0
            newPtr.storeBytes(of: value, as: IntArray.self)
        }

        ptr = newPtr
        capacity = newCap
    }

    mutating func free() {
        ptr?.deallocate()
        ptr = nil
        capacity = 0
    }
}

func checkFlexibleArrayMember() {
    var array = SwiftIntArray()
    array.append(10)
    array.append(34)
    array.append(42)
    array.append(89)
    
    print(array.count)
    
    for index in 0 ..< array.count {
        if let value = array.get(index) {
            print(value)
        }
    }
}
