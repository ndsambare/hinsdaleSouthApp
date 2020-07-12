//
//  Teacher.swift
//  Hinsdale South High School App
//
//  Created by Sagar Natekar on 12/31/15.
//  Copyright © 2015 Hornet App Development. All rights reserved.
//

import Foundation

class Teacher: NSObject, NSCoding {
    var firstName: String?
    var lastName: String?
    var email: String?
    var phone: String?
    var url: String?
    var department: String?

    struct Mapping {
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let email = "email"
        static let phone = "phone"
        static let url = "url"
        static let department = "department"
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init()

        firstName = aDecoder.decodeObject(forKey: Mapping.firstName) as? String
        lastName = aDecoder.decodeObject(forKey: Mapping.lastName) as? String
        email = aDecoder.decodeObject(forKey: Mapping.email) as? String
        phone = aDecoder.decodeObject(forKey: Mapping.phone) as? String
        url = aDecoder.decodeObject(forKey: Mapping.url) as? String
        department = aDecoder.decodeObject(forKey: Mapping.department) as? String
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(firstName, forKey: Mapping.firstName)
        aCoder.encode(lastName, forKey: Mapping.lastName)
        aCoder.encode(email, forKey: Mapping.email)
        aCoder.encode(phone, forKey: Mapping.phone)
        aCoder.encode(url, forKey: Mapping.url)
        aCoder.encode(department, forKey: Mapping.department)
    }
}
