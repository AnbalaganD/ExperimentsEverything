//
//  Foo.swift
//  ExperimentsEverything
//
//  Created by Anbalagan on 17/09/26.
//

struct Foo: Encodable {
    let label: String
    let count: Int?
}

struct FooPreserveNil: Encodable {
    let label: String
    @NullEncodable var count: Int?

    init(label: String, count: Int? = nil) {
        self.label = label
        self.count = count
    }
}
