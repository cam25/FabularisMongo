//
//  MongoModelRepresentable
//  Fabularis
//
//  Created by Daniel Skevarp on 2017-04-20.
//
//

import Foundation
import HTTP
import Vapor
import MongoKitten

public protocol MongoModelRepresentable : ResponseRepresentable, JSONRepresentable, NodeRepresentable{
    init()
    
    //  Reference to document
    var document : MongoKitten.Document { get set }
    static var MongoDB : MongoKitten.Database { get }
    //  Reference to collection
    static var collection : MongoKitten.Collection { get }
    
    // Reference to id
    var id : ObjectId {get set}
    
    func fillByDocument(document: Document)
    func save() throws
    func insert() throws
    func delete() throws
    static func all() throws -> [Self]
    static func prepare() throws
    static func revert() throws
    
    func willSave()
    func willInsert()
    func willDelete()
    func didSave()
    func didInsert()
    func didDelete()
    
}

extension MongoModelRepresentable {
    
    static func entity(id _id : ObjectId) throws -> Self {
        return try Self(id: _id)
    }
    
    init(id _id : ObjectId) throws
    {
        self.init()
        let query : Query = "_id" == _id
        guard let _document = try Self.collection.findOne(query) else {
            fatalError()
        }
        
        self.fillByDocument(document: _document)
    }
    
    static var name: String {
        return String(describing: self).lowercased()
    }
    
    public static var collection: MongoKitten.Collection {
        get {
            return MongoDB[Self.name]
        }
    }
    
    public func willSave() {}
    public func didSave() {}
    public func willInsert() {}
    public func didInsert() {}
    public func willDelete() {}
    public func didDelete() {}
    
    public func insert() throws
    {
        willInsert()
        try Self.collection.insert( self.document)
        didInsert()
    }
    
    public func save() throws
    {
        willSave()
        try Self.collection.update("_id" == id, to: self.document , upserting: true)
        didSave()
    }
    
    public static func all() throws -> [Self]
    {
        var all = [Self]()
        try Self.collection.find().forEach { (Document) in
            let new = try Self(id: ObjectId(Document["_id"])!)
            all.append(new)
        }
        
        return all
    }
    
    public func delete() throws
    {
        willDelete()
        try Self.collection.remove("_id" == self.id)
        didDelete()
    }
    
    
    
}

