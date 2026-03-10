//
//  main.swift
//  ExperimentsEverything
//
//  Created by Anbalagan on 08/11/24.
//

let includeDetails = true

let document = JSON {
    Field("title", "Unified Node Demo")
    Field("version", 2)
    
    if includeDetails {
        Field("author", "Anbalagan")
    }
    
    // Nested Object (detected via Fields)
    Field("metadata") {
        Field("created_at", "2024-12-25")
    }
    
    // Nested Array (detected via values)
    Field("tags") {
        "swift"
        "dsl"
        "unified"
    }
}

let arrayDocument = JSON {
    "Item 1"
    100
    // Embed existing JSON
    JSON {
        Field("nested", true)
    }
    // Direct array
    [Node.integer(200), .integer(300)]
}

print("--- Object ---")
print(document)
print("\n--- Array ---")
print(arrayDocument)


let manualJSON = JSON {
    JSONBuilder.buildExpression(Field("title", "Unified Node Demo"))
    JSONBuilder.buildExpression(Field("version", 2))
    JSONBuilder.buildOptional(
        includeDetails ? JSONBuilder.buildExpression(Field("author", "Anbalagan")) : nil
    )
    JSONBuilder.buildExpression(
        Field("metadata") {
            JSONBuilder.buildBlock(
                JSONBuilder.buildExpression(Field("created_at", "2024-12-25"))
            )
        }
    )
    JSONBuilder.buildExpression(
        JSONBuilder.buildExpression(Field("tags") {
            JSONBuilder.buildExpression("swift")
            JSONBuilder.buildExpression("dsl")
            JSONBuilder.buildExpression("unified")
        })
    )
}

print(manualJSON)

