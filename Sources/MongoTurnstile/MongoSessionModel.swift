//
//  MongoSessionModel.swift
//  Fabularis
//
//  Created by Daniel Skevarp on 2017-04-25.
//a
//


import MongoKitten
import HTTP
import Vapor
import Turnstile
import MongoModel


//protocol MongoSessionModelProtocol : MongoModelRepresentable, Account
//{
//    
//    var modelId : ObjectId { get }
//    
//}


final class MongoSessionModel : MongoModelRepresentable, Account{
    
    static var MongoDB: MongoKitten.Database {
        get {
           return MongoDatabaseProvider.instance.MongoDB!
        }
    }
    /**
     The account ID. Since a SessionManager can only be paired with one Realm,
     the uniqueID only needs to be unique within the Realm that generated the Account.
     */
    var uniqueID: String {
        return self.id.hexString
    }
    
    var id: ObjectId
    var modelId : String
    public var sessionId : String
    var document : Document{
        get {
            return [ "_id" : self.id,
                     "sessionId" : self.sessionId,
                     "modelId" : self.modelId
            ]
        }set {
            self.document = newValue
        }
    }
    
    
    required init() {
        self.id = ObjectId()
        self.sessionId = ""
        self.modelId = ""
    }
    
    convenience init?(sessionId _sessionid : String) throws {
        guard let _document = try MongoSessionModel.collection.findOne("sessionId" == _sessionid) else
        {
            return nil
        }
        self.init()
        self.fillByDocument(document: _document)
    }
    
    func fillByDocument(document: Document) {
        self.id = ObjectId(document["_id"])!
        self.sessionId = document["sessionId"]! as! String
        self.modelId = document["modelId"]! as! String
        
    }
    
    static func create(sessionId _sessionid : String, modelId _modelid : String) throws -> MongoSessionModel {
        let model = MongoSessionModel.init()
        model.sessionId = _sessionid
        model.id = ObjectId()
        model.modelId = _modelid
        try model.save()
        return model
    }
    
    
}

extension MongoSessionModel {
    func makeNode(context: Context) throws -> Node {
        throw Abort.badRequest
    }
    static func revert() throws {
        
    }
    
    func makeResponse() throws -> Response {
        throw Abort.badRequest
    }
    
    static func prepare() throws {
        
    }
    
}
