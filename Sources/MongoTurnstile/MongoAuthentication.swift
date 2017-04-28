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

public enum AuthenticationType: Credentials {
    case APIKey(APIKey), AccessToken(AccessToken), Identifier(Identifier), UsernamePassword(UsernamePassword)
}

extension MongoAuthentication {
    public static func authenticate(credentials: AuthenticationType) throws -> MongoAuthentication {
        switch credentials {
        case .APIKey(let apiKey):
            return try authenticate(apiKey: apiKey)
        case .AccessToken(let accessToken):
            return try authenticate(accessToken: accessToken)
        case .Identifier(let identifier):
            return try authenticate(identifier: identifier)
        case .UsernamePassword(let UsernamePassword):
           return try authenticate(username: usernamePassword.username, password: usernamePassword.password)
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
