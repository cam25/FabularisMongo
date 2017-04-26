//
//  MongoSessionManager.swift
//  Fabularis
//
//  Created by Daniel Skevarp on 2017-04-25.
//
//

//import Foundation
import Turnstile
import Random
import Auth

final class MongoSessionManager: SessionManager{
    private let realm: Realm
    
    public init(realm: Realm) {
        self.realm = realm
    }
    
    var cache : [MongoSessionModel] = [MongoSessionModel]()
    
    
    
    
    public func restoreAccount(fromSessionID identifier: String) throws -> Account {
        
        guard let session = try getSessionModelBy(identifier: identifier) else
        {
            throw AuthError.invalidIdentifier
        }
        
        return try realm.authenticate(credentials: Identifier(id: session.modelId))
        //        return session as Account
    }
    
    public func createSession(account: Account) -> String {
        let identifier = try! CryptoRandom.bytes(count: 16).base64Encoded.string
        let session = try? MongoSessionModel.create(sessionId: identifier, modelId: account.uniqueID)
        self.cache.append(session!)
        return identifier
    }
    
    public func destroySession(identifier: String) {
        let session = try? getSessionModelBy(identifier: identifier)
        try? session??.delete()
        if let index = cache.index(where: { $0.sessionId == session??.sessionId }) {
            cache.remove(at: index)
        }
    }
    
}

extension MongoSessionManager {
    
    func getSessionModelBy(identifier : String) throws -> MongoSessionModel?
    {
        for model in cache
        {
            if model.sessionId == identifier {
                return model
            }
        }
        
        guard let model = try MongoSessionModel.init(sessionId: identifier) else {
            
            return nil
        }
        
        return model
    }
}
