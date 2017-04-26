//
//  MongoKittenRealm.swift
//  Fabularis
//
//  Created by Daniel Skevarp on 2017-04-24.
//a
//

import Turnstile
import Auth

public final class MongoKittenRealm<A: MongoAuthenticator>: Realm {
    public init(_ a: A.Type = A.self) { }
    
    public func authenticate(credentials: Credentials) throws -> Account {
        return try A.authenticate(credentials: credentials)
    }
    
    public func register(credentials: Credentials) throws -> Account {
        return try A.register(credentials: credentials)
    }
}



