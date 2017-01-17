import URI
import HTTP
import Vapor
import VaporMySQL
import Auth
//import VaporMemory

let drop = Droplet()

drop.preparations.append(people.self)
drop.resource("people", PeopleController())
//try drop.addProvider(VaporMemory.Provider.self)
try drop.addProvider(VaporMySQL.Provider.self)

let auth = AuthMiddleware(user: User.self)
drop.middleware.append(auth)

drop.get("hello"){
    request in
    return "hello World!"
}

drop.get { req in
    return try drop.view.make("welcome", [
    	"message": drop.localization[req.lang, "welcome", "title"]
    ])
}


drop.group("users") { users in
    users.post { req in
        guard let name = req.data["name"]?.string else {
            throw Abort.badRequest
        }
        
        
        var user = User(name: name)
        try user.save()
        return user
    }
    
    users.post("login") { req in
        guard let id = req.data["id"]?.string else {
            throw Abort.badRequest
        }
        
        let creds = try Identifier(id: id)
        try req.auth.login(creds)
        
        return try JSON(node: ["message": "Logged in"])
    }
    
    users.get {
        req in
        guard let id = req.data["id"]?.string else {
            throw Abort.badRequest
        }
        
        let creds = try Identifier(id: id)
        try req.auth.login(creds)
        
        
        
        return try JSON(node: ["message": "Logged in"])
    }
    
    let protect = ProtectMiddleware(error:
        Abort.custom(status: .forbidden, message: "Not authorized.")
    )
    users.group(protect) { secure in
        secure.get("secure") { req in
            return try req.user()
        }
    }
}

drop.run()
