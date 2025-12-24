//
//  BitField.swift
//  ExperimentsEverything
//
//  Created by Anbalagan on 19/12/25.
//

import core

func checkBitFiled() {
    var unixPermission = unix_permission_create()
    
    print("Read: \(unixPermission.read == 1)")
    print("Write: \(unixPermission.write == 1)")
    print("Execute: \(unixPermission.execute == 1)")
    print("\nSize of unix_permission: \(MemoryLayout<unix_permission>.size) Byte\n")
    
    //Map to Swift Type
    let permission = withUnsafeMutableBytes(of: &unixPermission) { pointer in
//        pointer.assumingMemoryBound(to: UnixPermission.self).baseAddress?.pointee
        pointer.load(as: UnixPermission.self)
    }
    
    print("Read: \(permission.contains(.read))")
    print("Write: \(permission.contains(.write))")
    print("Execute: \(permission.contains(.execute))")
}

extension unix_permission_t {
    var rawValue: UInt8 {
        get { withUnsafeBytes(of: self) { $0.load(as: UInt8.self) } }
        set {
            withUnsafeMutableBytes(of: &self) { ptr in
                ptr.storeBytes(of: newValue, as: UInt8.self)
            }
        }
    }
}

struct UnixPermission: OptionSet {
    var rawValue: UInt8
    
    static let read: UnixPermission = .init(rawValue: 1 << 0)
    static let write: UnixPermission = .init(rawValue: 1 << 1)
    static let execute: UnixPermission = .init(rawValue: 1 << 2)
}
