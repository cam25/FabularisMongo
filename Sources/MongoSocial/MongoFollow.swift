//
//  MongoFollow
//  Fabularis
//
//  Created by Daniel Skevarp on 2017-04-27.
//

import Foundation
import MongoKitten
import MongoModel

protocol MongoFollow: MongoModelRepresentable {
    
    var followers : [ObjectId] {get set}
    var follows : [ObjectId] {get set}
    var followRequests : [ObjectId] {get set}
    var followersRequests : [ObjectId] {get set}
    
    func isUserFollowedBy(id _id : ObjectId) -> Bool
    func isUserFollowing(id _id : ObjectId) -> Bool
    mutating func addFollower(id _id : ObjectId)
    mutating func followUser(id _id : ObjectId)
    mutating func addFollowRequest(id _id : ObjectId)
    mutating func addFollowerRequest(id _id : ObjectId) throws
    mutating func acceptFollowerRequestFrom(id _id : ObjectId)
    mutating func followRequestAccepted(id _id :ObjectId)
    
}

extension MongoFollow {
    
    func isUserFollowedBy(id _id : ObjectId) -> Bool
    {
        var isFollower = false
        for follower in self.followers
        {
            if follower == _id
            {
                isFollower = true
            }
        }
        
        return isFollower
    }
    
    func isUserFollowing(id _id : ObjectId) -> Bool
    {
        var isFollowing = false
        for following in self.follows
        {
            if following == _id
            {
                isFollowing = true
            }
        }
        
        return isFollowing
    }
    
    mutating func addFollower(id _id : ObjectId)
    {
        if isUserFollowedBy(id: _id) == false
        {
            self.followers.append(_id)
        }
    }
    
    mutating func followUser(id _id : ObjectId)
    {
        if isUserFollowing(id: _id) == false
        {
            self.follows.append(_id)
        }
    }
    
    mutating func addFollowRequest(id _id : ObjectId)
    {
        var isRequested = false
        for request in self.followRequests
        {
            if request == _id{ isRequested = true }
        }
        
        if isRequested == false {
            if isUserFollowedBy(id: _id) == false
            {
                followRequests.append(_id)
            }
        }
    }
    
    mutating func addFollowerRequest(id _id : ObjectId) throws
    {
        var isRequested = false
        
        for request in self.followersRequests
        {
            if request == _id { isRequested = true }
        }
        if isRequested == false
        {
            if isUserFollowing(id: _id) == false
            {
                followersRequests.append(_id)
                try self.save()
            }
        }
    }
    
    mutating func acceptFollowerRequestFrom(id _id : ObjectId) {
        self.followersRequests.remove(object: _id)
        self.followers.append(_id)
    }
    
    mutating func followRequestAccepted(id _id :ObjectId)
    {
        self.followRequests.remove(object: _id)
        self.follows.append(_id)
    }
    
    
}
