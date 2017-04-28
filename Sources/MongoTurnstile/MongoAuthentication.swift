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

public enum AuthenticationType: Credentials {
    case APIKey(APIKey), AccessToken(AccessToken), Identifier(Identifier)
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
