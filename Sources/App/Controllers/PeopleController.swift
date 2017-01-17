//
//  PeopleController.swift
//  Users
//
//  Created by Prateek Kansara on 17/01/17.
//
//

import Vapor
import HTTP

final class PeopleController: ResourceRepresentable {
    
    func index(request: Request) throws -> ResponseRepresentable {
        guard let id = request.data["id"] else {
            return try people.database?.driver.raw("Select id,firstname,age,profileImage,city from peoples").makeNode().converted(to: JSON.self) as! ResponseRepresentable
        }

        let peopleFound = try people.database?.driver.raw("Select * from peoples where id=\(id.int!)")
        
        if (peopleFound?.nodeArray?.count)! > 0{
            return try peopleFound?.makeNode().converted(to: JSON.self) as! ResponseRepresentable
        }
        return try JSON(node: ["message": "Invalid id"])
//        return try people.database?.driver.raw("Select * from peoples where id=\(id.int!)").makeNode().converted(to: JSON.self) as! ResponseRepresentable
        
//        return try people.all().makeNode().converted(to: JSON.self)
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        var People = try request.People()
        try People.save()
        return People
    }

    func show(request: Request, People: people) throws -> ResponseRepresentable {
        return People
    }

    func delete(request: Request, People: people) throws -> ResponseRepresentable {
        try People.delete()
        return JSON([:])
    }
    
    func clear(request: Request) throws -> ResponseRepresentable {
        try people.query().delete()
        return JSON([])
    }
    
    func update(request: Request, People: people) throws -> ResponseRepresentable {
        let new = try request.People()
        var People = People
        People.firstname = new.firstname
        People.lastname = new.lastname
        People.age = new.age
        People.imageUrl = new.imageUrl
        People.address = new.address
        People.job = new.job
        People.postcode = new.postcode
        People.phone = new.phone
        People.city = new.city
        
        try People.save()
        return People
    }
    
    func replace(request: Request, People: people) throws -> ResponseRepresentable {
        try People.delete()
        return try create(request: request)
    }
    
    
    func makeResource() -> Resource<people> {
        return Resource(
            index: index,
            store: create,
            show: show,
            replace: replace,
            modify: update,
            destroy: delete,
            clear: clear
        )
    }
}

extension Request {
    func People() throws -> people {
        guard let json = json else { throw Abort.badRequest }
        return try people(node: json)
    }
}
