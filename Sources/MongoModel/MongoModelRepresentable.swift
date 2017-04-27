//
//  MongoModelRepresentable
//  Fabularis
//
//  Created by Daniel Skevarp on 2017-04-20.
// a
//

import Foundation
import HTTP
import Vapor
import MongoKitten

public protocol MongoModelRepresentable : ResponseRepresentable, JSONRepresentable, NodeRepresentable,StringInitializable{
    init()
    
    //  Reference to document
    var document : MongoKitten.Document { get }
//   singleton class for DB (maybe move to config instead)
    static var MongoDB : MongoKitten.Database { get }
    //  Reference to collection
    static var collection : MongoKitten.Collection { get }
    // Reference to id
    var id : ObjectId {get set}
    
    init(document _document : Document)
    
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
    
    
//    static func entity(id _id : ObjectId) throws -> Self
    
}

extension MongoModelRepresentable {
    
    public static func prepare() throws {
        
    }
    
    public static func revert() throws {
        
    }
    
    public init(id _id : ObjectId) throws
    {
        guard let document = try Self.collection.findOne("_id" == _id) else {
            throw Abort.notFound
        }
        self.init(document: document)
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
        return try Array((Self.collection.find().flatMap { Self.init(document: $0) }))
    }
    
    public func delete() throws
    {
        willDelete()
        try Self.collection.remove("_id" == self.id)
        didDelete()
    }
    
//    TODO: Pagination function
    
    
    
}

