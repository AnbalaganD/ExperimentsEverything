// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ExperimentsEverything",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .executable(name: "KVC", targets: ["KVC"]),
        .executable(name: "JSONEncoder", targets: ["JSONEncoder"]),
        .executable(name: "MemoryLayout", targets: ["MemoryLayout"]),
        .executable(name: "InterOperateWithC", targets: ["InterOperateWithC"]),
        .executable(name: "TypeCast", targets: ["TypeCast"]),
        .executable(name: "ConsumeBarrow", targets: ["ConsumeBarrow"])
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "KVC",
            path: "Sources/KeyValueCoding(KVC)/"
        ),
        .executableTarget(
            name: "JSONEncoder",
            path: "Sources/JSONEncoder/"
        ),
        .executableTarget(
            name: "MemoryLayout",
            path: "Sources/MemoryLayout/"
        ),
        .executableTarget(
            name: "InterOperateWithC",
            path: "Sources/InterOperateWithC/"
        ),
        .executableTarget(
            name: "TypeCast",
            path: "Sources/TypeCast/"
        ),
        .executableTarget(
            name: "ConsumeBarrow",
            path: "Sources/ConsumeBarrow/"
        )
    ]
)
