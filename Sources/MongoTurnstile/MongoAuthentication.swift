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
    
}

extension MongoAuthentication {
    public static func authenticate(credentials: Credentials) throws -> MongoAuthentication {
        if let apiKey = credentials as? APIKey {
            return try authenticate(apiKey: apiKey)
        } else if let accessToken = credentials as? AccessToken {
            return try authenticate(accessToken: accessToken)
        } else if let identifier = credentials as? Identifier {
            return try authenticate(identifier: identifier)
        } else {
            throw AuthError.unsupportedCredentials
        }
    }
    
    public static func authenticate(apiKey: APIKey) throws -> MongoAuthentication {
        //        guard
        //            let match = try Self
        //                .query()
        //                .filter("api_key_id", apiKey.id)
        //                .filter("api_key_secret", apiKey.secret)
        //                .first()
        //            else {
        //                throw AuthError.invalidCredentials
        //        }
        
        throw AuthError.invalidCredentials
    }
    
    public static func authenticate(accessToken: AccessToken) throws -> MongoAuthentication {
        //        guard
        //            let match = try Self
        //                .query()
        //                .filter("access_token", accessToken.string)
        //                .first()
        //            else {
        throw AuthError.invalidCredentials
        //        }
        //
        //        return match
    }
    
    public static func authenticate(identifier: Identifier) throws -> MongoAuthentication {
        guard
            let match = try Self.find(identifier: identifier)
            else {
                throw AuthError.invalidCredentials
        }
        
        return match
    }
}
