//
//  main.swift
//  ExperimentsEverything
//
//  Created by Anbalagan on 07/11/24.
//

struct User {
    var name: String
}

func checkOwnership() {
    let newUser = User(name: "Anonymous")
    let userCopy = consume newUser
    print(userCopy.name)
    
    // Uncomment below line see the compiler error
    // print(newUser)
    
    let anbalagan = User(name: "Anbalagan")
    takeFullControl(anbalagan)
    print(anbalagan)
    
    takeFullControl(consume anbalagan) // Pass full ownership to this function
    // Uncomment below line see the compiler error
    // print(anbalagan)
}

checkOwnership()
modifyAndPrint(User(name: "Anonymous"))


func modifyAndPrint(_ user: borrowing User) {
    // Uncomment below line see the compiler error
    // user.name = "Hello"
    
    // Here `copy` is contextual keywork
    var anbu = copy user
    anbu.name = "Anbu"
    print(user.name)
    print(anbu)
}

// This function we can modify the user parameter
func takeFullControl(_ user: consuming User) {
    user.name = "Anbu"
    print(user)
    user = User(name: "Anbu D")
    print(user)
}
