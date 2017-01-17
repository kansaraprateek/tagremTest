//
//  people.swift
//  People
//
//  Created by Prateek Kansara on 05/01/17.
//
//

import Foundation
import Vapor
import Fluent

final class people: Model{
    
    var id: Node?
    var firstname : String?
    var lastname : String?
    var age : Int?
    var imageUrl: String?
    var address: String?
    var job: String?
    var postcode: String?
    var phone: String?
    var city: String?
    
    var exists: Bool = false
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        firstname = try node.extract("firstname")
        lastname = try node.extract("lastname")
        age = try node.extract("age")
        imageUrl = try node.extract("imageUrl")
        address = try node.extract("address")
        job = try node.extract("job")
        postcode = try node.extract("postcode")
        phone = try node.extract("phone")
        city = try node.extract("city")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "firstname": firstname,
            "lastname": lastname,
            "age": age,
            "imageUrl": imageUrl,
            "address": address,
            "job": job,
            "postcode": postcode,
            "phone": phone,
            "city": city
            ])
    }

}

//extension people : NodeConvertible{
//    
//  
//}

extension people : Preparation{
    static func prepare(_ database: Database) throws {
        //        try database.create("users") { users in
        //            users.id()
        //            users.string("firstname")
        //            users.string("lastname")
        //            users.string("age")
        //            users.string("imageUrl")
        //            users.string("address")
        //            users.string("job")
        //            users.string("postcode")
        //            users.string("phone")
        //            users.string("city")
        //        }
        //
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("people")
    }
}

//// MARK: Merge
//
//extension people {
//    mutating func merge(updates: people) {
//        id = updates.id ?? id
//        firstname = updates.firstname ?? firstname
//        lastname = updates.lastname ?? lastname
//        age = updates.age ?? age
//        imageUrl = updates.imageUrl ?? imageUrl
//        address = updates.address ?? address
//        job = updates.job ?? job
//        postcode = updates.postcode ?? postcode
//        phone = updates.phone ?? phone
//        city = updates.city ?? city
//    }
//}
