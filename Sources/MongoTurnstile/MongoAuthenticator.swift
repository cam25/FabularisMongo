//
//  MongoAuthenticator.swift
//  Fabularis
//
//  Created by Daniel Skevarp on 2017-04-24.
//
//

import Foundation
import Turnstile
import HTTP
import Auth
import MongoKitten

@_exported import protocol Turnstile.Credentials

public protocol MongoAuthenticator {
    static func authenticate(credentials: Credentials) throws -> MongoAuthentication
    static func register(credentials: Credentials) throws -> MongoAuthentication
}

extension Request {
    func MongoSubject() throws -> Subject {
        guard let subject = storage["subject"] as? Subject else {
            throw AuthError.noSubject
        }
        return subject
    }
}


// FilePrivate until we can move to Core
fileprivate class Weak<T: AnyObject> {
    private(set) weak var value: T?
    
    init(_ value: T) {
        self.value = value
    }
}

extension Request {
    public var auth: Helper {
        let key = "triprAuth"
        
        guard let wrapper = storage[key] as? Weak<Helper>, let helper = wrapper.value else {
            let helper = Helper(request: self)
            storage[key] = Weak(helper)
            return helper
        }
        
        return helper
    }
}

public final class Helper {
    public let request: Request
    public init(request: Request) {
        self.request = request
    }
    
    public var header: Authorization? {
        guard let authorization = request.headers["Authorization"] else {
            return nil
        }
        
        return Authorization(header: authorization)
    }
    
    public func login(_ credentials: Credentials, persist: Bool = true) throws {
        return try request.MongoSubject().login(credentials: credentials, persist: persist)
    }
    
    public func logout() throws {
        return try request.MongoSubject().logout()
    }
    
    public func user() throws -> MongoAuthentication {
        let subject = try request.MongoSubject()
        
        guard let details = subject.authDetails else {
            throw AuthError.notAuthenticated
        }
        //        let user = TriprModelRepresentable.entity(id: subject.sessionIdentifier )
        
        guard let user = details.account as? MongoAuthentication else {
            throw AuthError.invalidAccountType
        }
        //        let user = try TriprModelRepresentable.init(id: ObjectId(details.account.uniqueID))
        
        return user
    }
}

