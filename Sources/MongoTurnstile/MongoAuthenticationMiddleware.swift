//
//  MongoAuthenticationMiddleware.swift
//  Fabularis
//
//  Created by Daniel Skevarp on 2017-04-24.
//a
//

import Turnstile
import HTTP
import Cookies
import Foundation
import Cache
import Auth

private let defaultCookieName = "tripr"
private let cookieTimeout: TimeInterval = 7 * 24 * 60 * 60

public class MongoAuthMiddleware<U: MongoAuthentication>: Middleware {
    private let turnstile: Turnstile
    private let cookieName: String
    private let cookieFactory: CookieFactory
    private let refreshCookieEveryRequest: Bool
    
    public typealias CookieFactory = (String) -> Cookie
    
    public init(
        turnstile: Turnstile,
        cookieName: String = defaultCookieName,
        refreshCookieEveryRequest: Bool = false,
        makeCookie cookieFactory: CookieFactory?
        ) {
        self.turnstile = turnstile
        self.cookieName = cookieName
        self.refreshCookieEveryRequest = refreshCookieEveryRequest
        self.cookieFactory = cookieFactory ?? { value in
            return Cookie(
                name: cookieName,
                value: value,
                expires: Date().addingTimeInterval(cookieTimeout),
                secure: false,
                httpOnly: true
            )
        }
    }
    
    public convenience init(
        user: U.Type = U.self,
        realm: Realm = MongoKittenRealm(U.self),
        cache: CacheProtocol = MemoryCache(),
        cookieName: String = defaultCookieName,
        refreshCookieEveryRequest: Bool = false,
        makeCookie cookieFactory: CookieFactory? = nil
        ) {
        let session = MongoSessionManager(realm: realm)
        let turnstile = Turnstile(sessionManager: session, realm: realm)
        self.init(turnstile: turnstile, cookieName: cookieName, refreshCookieEveryRequest: refreshCookieEveryRequest, makeCookie: cookieFactory)
    }
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        request.storage["subject"] = Subject(
            turnstile: turnstile,
            sessionID: request.cookies[cookieName]
        )
        
        let response = try next.respond(to: request)
        
        // If we have a new session, set a new cookie
        if
            let sid = try request.mongoSubject().sessionIdentifier,
            request.cookies[cookieName] != sid ||
            refreshCookieEveryRequest
        {
            var cookie = cookieFactory(sid)
            cookie.name = cookieName
            response.cookies.insert(cookie)
        } else if
            try request.mongoSubject().sessionIdentifier == nil,
            request.cookies[cookieName] != nil
        {
            // If we have a cookie but no session, delete it.
            response.cookies[cookieName] = nil
        }
        
        return response
    }
}

extension Subject {
    var sessionIdentifier: String? {
        return authDetails?.sessionID
    }
}

