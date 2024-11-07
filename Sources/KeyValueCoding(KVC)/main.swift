//
//  main.swift
//  ExperimentsEverything1
//
//  Created by Anbalagan on 07/11/24.
//

var employee = Employee(name: "Anbu", experience: 7)
employee.setValue("Anbalagan D", forKey: "name")
employee.setValue(8, forKey: "experience")

// We can pass string also.
// If we pass incorrect value like "Eight" set to zero (0)
employee.setValue("10", forKey: "experience")

print(employee.name)
print(employee.experience)
