//
//  MongoLikeable
//  Fabularis
//
//  Created by Daniel Skevarp on 2017-04-27.
//

import Foundation
import MongoKitten

protocol MongoLikable {
    
    var likes : [ObjectId] {get set}
        
    func addLikeBy(id _id : ObjectId)
    func removeLikeBy(id _id : ObjectId)
    func isLikedByUser(id _id : ObjectId) -> Bool
    
}

extension MongoLikable {
    
    public mutating func addLikeBy(id _id : ObjectId){
        self.likes.append(_id)
    }
    
    public mutating func removeLikeBy(id _id : ObjectId){
        self.likes.remove(object: _id)
    }
    
    public func isLikedByUser(id _id : ObjectId) -> Bool
    {
        return self.likes.contains(_id)
    }
}
