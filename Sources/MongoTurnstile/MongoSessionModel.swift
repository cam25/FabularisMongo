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

final class MongoSessionModel : MongoModelRepresentable, Account{
    
    init(document _document: Document) {
        self.id = ObjectId(_document["_id"])!
        self.sessionId = _document["sessionId"]! as! String
        self.modelId = _document["modelId"]! as! String
    }

    
    static var MongoDB: MongoKitten.Database {
        get {
           return MongoDatabaseProvider.instance.MongoDB!
        }
    }
    
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
    
    convenience init?(from string: String) throws {
        guard let _document = try MongoSessionModel.collection.findOne("sessionId" == string) else
        {
            return nil
        }
        self.init(document: _document)
    }

    convenience init?(sessionId _sessionid : String) throws {
        try self.init(from: _sessionid)
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
