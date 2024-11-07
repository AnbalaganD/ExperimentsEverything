//
//  Employee.swift
//  ExperimentsEverything1
//
//  Created by Anbalagan on 07/11/24.
//

import Foundation

final class Employee: NSObject {
    @objc dynamic var name: String
    @objc dynamic var experience: Int
    
    init(name: String, experience: Int) {
        self.name = name
        self.experience = experience
    }
}
