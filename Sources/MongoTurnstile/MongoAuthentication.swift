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
    static func authenticate(apiKey: APIKey) throws -> MongoAuthentication
    static func authenticate(accessToken: AccessToken) throws -> MongoAuthentication
    static func authenticate(identifier: Identifier) throws -> MongoAuthentication
    static func authenticate(username: String, password: String) throws -> MongoAuthentication
}

extension MongoAuthentication {
    public static func authenticate(credentials: Credentials) throws -> MongoAuthentication {
        if let apiKey = credentials as? APIKey {
            return try authenticate(apiKey: apiKey)
        } else if let accessToken = credentials as? AccessToken {
            return try authenticate(accessToken: accessToken)
        } else if let identifier = credentials as? Identifier {
            return try authenticate(identifier: identifier)
        } else if let usernamePassword = credentials as? UsernamePassword{
            return try authenticate(username: usernamePassword.username, password: usernamePassword.password)
        }
        else {
            throw AuthError.unsupportedCredentials
        }
    }
    
//    generic authentication handling
    public static func authenticate(identifier: Identifier) throws -> MongoAuthentication {
        guard
            let match = try Self.find(identifier: identifier)
            else {
                throw AuthError.invalidCredentials
        }
        
        return match
    }
}
