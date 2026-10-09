//
//  NullEncodable.swift
//  ExperimentsEverything
//
//  Created by Anbalagan on 17/09/26.
//

@propertyWrapper
struct NullEncodable<T: Encodable>: Encodable {
    var wrappedValue: T?

    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        if let value = wrappedValue {
            try container.encode(value)
        } else {
            try container.encodeNil()
        }
    }
}
