//
//  JSONBuilder.swift
//  ExperimentsEverything
//
//  Created by Anbalagan on 25/12/25.
//


import Foundation

@resultBuilder
struct JSONBuilder {
    static func buildBlock(_ components: [Node]...) -> [Node] {
        return components.flatMap { $0 }
    }
    
    static func buildExpression(_ node: Node) -> [Node] {
        return [node]
    }
    
    static func buildExpression(_ expression: String) -> [Node] {
        return [.string(expression)]
    }
    
    static func buildExpression(_ expression: Int) -> [Node] {
        return [.integer(expression)]
    }
    
    static func buildExpression(_ expression: Double) -> [Node] {
        return [.floating(expression)]
    }
    
    static func buildExpression(_ expression: Bool) -> [Node] {
        return [.boolean(expression)]
    }
    
    // Support embedding existing JSON object
    static func buildExpression(_ expression: JSON) -> [Node] {
        return [expression.root]
    }
    
    // Support embedding array of Nodes
    static func buildExpression(_ components: [Node]) -> [Node] {
        return components
    }
    
    static func buildOptional(_ component: [Node]?) -> [Node] {
        return component ?? []
    }
    
    static func buildEither(first component: [Node]) -> [Node] {
        return component
    }
    
    static func buildEither(second component: [Node]) -> [Node] {
        return component
    }
    
    static func buildArray(_ components: [[Node]]) -> [Node] {
        return components.flatMap { $0 }
    }
}

// Single Unified Node Type
indirect enum Node: CustomStringConvertible {
    case object([Node])
    case array([Node])
    case field(String, Node)
    case string(String)
    case integer(Int)
    case floating(Double)
    case boolean(Bool)
    case null
    
    var description: String {
        return description(indent: 0)
    }
    
    func description(indent: Int) -> String {
        switch self {
        case .string(let value): return "\"\(value)\""
        case .integer(let value): return "\(value)"
        case .floating(let value): return "\(value)"
        case .boolean(let value): return "\(value)"
        case .null: return "null"
        
        case .field(let key, let value):
            let indentation = String(repeating: "  ", count: indent)
            return "\(indentation)\"\(key)\": \(value.description(indent: indent))"
            
        case .object(let nodes):
            if nodes.isEmpty { return "{}" }
            let innerIndent = indent + 1
            let closingIndentation = String(repeating: "  ", count: indent)
            let fields = nodes.map { $0.description(indent: innerIndent) }.joined(separator: ",\n")
            return "{\n\(fields)\n\(closingIndentation)}"
            
        case .array(let nodes):
            if nodes.isEmpty { return "[]" }
            let innerIndent = indent + 1
            let closingIndentation = String(repeating: "  ", count: indent)
            
            let values = nodes.map { node -> String in
                let desc = node.description(indent: innerIndent)
                let prefix = String(repeating: "  ", count: innerIndent)
                return "\(prefix)\(desc)"
            }.joined(separator: ",\n")
            
            return "[\n\(values)\n\(closingIndentation)]"
        }
    }
}

struct JSON: CustomStringConvertible {
    let root: Node
    
    // Unified Initializer
    init(@JSONBuilder _ content: () -> [Node]) {
        let nodes = content()
        // Heuristic: If any child is a .field, treat as Object. Otherwise Array.
        // This is a simplification; valid JSON objects must ONLY contain fields.
        let isObject = nodes.contains {
            if case .field = $0 { return true }
            return false
        }
        
        if isObject {
            self.root = .object(nodes)
        } else {
            self.root = .array(nodes)
        }
    }
    
    var description: String {
        return root.description
    }
}

// Helpers
func Field(_ key: String, _ value: String) -> Node {
    .field(key, .string(value))
}

func Field(_ key: String, _ value: Int) -> Node {
    .field(key, .integer(value))
}

func Field(_ key: String, _ value: Double) -> Node {
    .field(key, .floating(value))
}

func Field(_ key: String, _ value: Bool) -> Node {
    .field(key, .boolean(value))
}

//// Allows Field("key", [1, 2])
//func Field(_ key: String, _ value: [Node]) -> Node {
//    .field(key, .array(value))
//}

// Allows Field("key") { ... }
// This uses the same builder, so it can return an Object or Array depending on content!
func Field(_ key: String, @JSONBuilder _ content: () -> [Node]) -> Node {
    let nodes = content()
    let isObject = nodes.contains {
        if case .field = $0 { return true }
        return false
    }
    
    if isObject {
        return .field(key, .object(nodes))
    } else {
        return .field(key, .array(nodes))
    }
}
