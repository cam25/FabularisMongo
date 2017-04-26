//
//  MongoAuthenticator.swift
//  Fabularis
//
//  Created by Daniel Skevarp on 2017-04-24.
//a
//

//import Foundation
import Turnstile
import HTTP
import Auth
//import MongoKitten

@_exported import protocol Turnstile.Credentials

public protocol MongoAuthenticator {
    static func authenticate(credentials: Credentials) throws -> MongoAuthentication
    static func register(credentials: Credentials) throws -> MongoAuthentication
}

// FilePrivate until we can move to Core
fileprivate class Weak<T: AnyObject> {
    private(set) weak var value: T?
    
    init(_ value: T) {
        self.value = value
    }
}

