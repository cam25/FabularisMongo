//
//  MongoAuthentication.swift
//  Fabularis
//
//  Created by Daniel Skevarp on 2017-04-21.
//a
//

import Turnstile
import Auth

public protocol MongoAuthentication: Account, MongoAuthenticator {
    static func find(identifier : Identifier) throws -> MongoAuthentication?
    static func find(apiKey : APIKey) throws -> MongoAuthentication?

    static func find(accessToken : AccessToken) throws -> MongoAuthentication?

    static func find(credentials : Credentials) throws -> MongoAuthentication?
    static func find(username : String, password : String) throws -> MongoAuthentication?

    static func authenticate(apiKey: APIKey) throws -> MongoAuthentication
    static func authenticate(accessToken: AccessToken) throws -> MongoAuthentication
    static func authenticate(identifier: Identifier) throws -> MongoAuthentication
    static func authenticate(username: String, password: String) throws -> MongoAuthentication
}

public enum AuthenticationType: Credentials {
    case APIKey(APIKey), AccessToken(AccessToken), Identifier(Identifier), UsernamePassword(UsernamePassword)
}


struct MongoDatabaseAuthenticationStructure: MongoAuthentication {
    
        public static func authenticate(credentials: AuthenticationType) throws -> MongoAuthentication {
                switch credentials {
                case .APIKey(let apiKey):
                    return try authenticate(apiKey: apiKey)
                case .AccessToken(let accessToken):
                    return try authenticate(accessToken: accessToken)
                case .Identifier(let identifier):
                    return try authenticate(identifier: identifier)
                case .UsernamePassword(let UsernamePassword):
                   return try authenticate(username: UsernamePassword.username, password: UsernamePassword.password)
            }
            
    }
    
    static func find(username: String, password: String) throws -> MongoAuthentication? {

    }

    static func find(credentials: Credentials) throws -> MongoAuthentication? {
        
    }

    static func find(accessToken: AccessToken) throws -> MongoAuthentication? {
        
    }

    static func find(apiKey: APIKey) throws -> MongoAuthentication? {
        
    }

    var uniqueID: String
    
    static func register(credentials: Credentials) throws -> MongoAuthentication {
        
    }
    
    static func authenticate(credentials: Credentials) throws -> MongoAuthentication {
        guard let match = try self.find(credentials: credentials) else {
            throw AuthError.invalidCredentials
        }
        return match
    }

    static func authenticate(username: String, password: String) throws -> MongoAuthentication {
        guard let match = try self.find(username: username, password: password) else {
            throw AuthError.invalidCredentials
        }
        return match

    }

    static func authenticate(identifier: Identifier) throws -> MongoAuthentication {
        guard let match = try self.find(identifier: identifier) else {
                 throw AuthError.invalidCredentials
            }
        return match
    }

    static func authenticate(accessToken: AccessToken) throws -> MongoAuthentication {
        guard let match = try self.find(accessToken: accessToken) else {
            throw AuthError.invalidAccountType
        }
        return match

    }

    static func authenticate(apiKey: APIKey) throws -> MongoAuthentication {
        guard let match = try self.find(apiKey: apiKey) else {
            throw AuthError.invalidAccountType
        }
        return match
   
    }

    static func find(identifier: Identifier) throws -> MongoAuthentication? {
        
    }

}
