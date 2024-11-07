//
//  main.swift
//  ExperimentsEverything
//
//  Created by Anbalagan on 07/11/24.
//

/**
 
Let say we have two struct one is called `Cycle` with amount property type Double.
Another one is called `Laptop` with price property type Double.
If try to type case normally using as keywork swift type system won't allow us to do this.
Because `Cycle` and `Laptop` are have different identifier technically they are different type.
But look closely both are structurally equal only identifier name and property name only changed
So we bypass the Swift type system check and TypeCast the `Cycle` instance into `Laptop`
 
*/

struct Cycle {
    let amount: Double
}

struct Laptop {
    let price: Double
}

let cycle: Cycle = Cycle(amount: 100)

// Uncomment below line see what will compiler throw runtime error
// let laptop: Laptop = cycle as! Laptop


// Here `unsafeBitCast` will bypass the Swift Type system and directly convert to destination type
// Warning: We should call this function with extra care
let laptop = unsafeBitCast(cycle, to: Laptop.self)
print(laptop.price)
