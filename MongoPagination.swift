//
//  MongoPagination.swift
//  tripr
//
//  Created by Cameron Mozie on 5/6/17.
//
//

import Vapor
import MongoKitten


struct MongoPagination {
    var mongoDB : MongoKitten.Database
    var collection : MongoCollection

    init(collection: MongoCollection, mongoDB: MongoKitten.Database) {
        self.collection = collection
        self.mongoDB = mongoDB
    }
    
    public func totalNumberOfPages() throws -> Int? {

        var query: CollectionSlice<Document>
        query = try self.collection.find()
        
        return try query.count()
    }
    
    func previousPage(currentPage: Int) throws ->  CollectionSlice<Document>?  {
        var query: CollectionSlice<Document>
        guard let totalNumberOfPages = try self.totalNumberOfPages() else {
            return nil
        }
        
        let previous = currentPage - 1
        guard previous >= 1 else { return nil }
        
        query = try self.collection.find(skipping: previous * totalNumberOfPages, limitedTo: totalNumberOfPages)
        
        return query
        
        
    }
}
