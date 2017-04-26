//
//  Request+Authenticator.swift
//  FabularisMongo
//
//  Created by Daniel Skevarp on 2017-04-26.
//
//

import Foundation
import Turnstile
import HTTP
import Auth
import MongoKitten

extension Request {
    func triprSubject() throws -> Subject {
        guard let subject = storage["subject"] as? Subject else {
            throw AuthError.noSubject
        }
        return subject
    }
}

fileprivate class Weak<T: AnyObject> {
    private(set) weak var value: T?
    
    init(_ value: T) {
        self.value = value
    }
}

extension Request {
    public var auth: Helper {
        let key = "MongoAuth"
        
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
        return try request.triprSubject().login(credentials: credentials, persist: persist)
    }
    
    public func logout() throws {
        return try request.triprSubject().logout()
    }
    
    public func user() throws -> MongoAuthentication {
        let subject = try request.triprSubject()
        
        guard let details = subject.authDetails else {
            throw AuthError.notAuthenticated
        }
        
        guard let user = details.account as? MongoAuthentication else {
            throw AuthError.invalidAccountType
        }
        
        return user
    }
}
